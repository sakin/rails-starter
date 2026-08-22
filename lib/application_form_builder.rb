# frozen_string_literal: true

# A Rails form builder that maps field methods to the `forms/*` view-component
# family. Each field method composes a `Forms::Field` wrapper around a typed
# control component, so `form.text_field :email, label: "Email address"` renders
# a proper labelled control in one call.
#
# Made the app-wide default via `config.action_view.default_form_builder` (see
# `config/application.rb`), so `form_with` uses it everywhere without passing a
# `builder:`. Name avoids colliding with `ActionView::Helpers::FormBuilder`.
#
# The `<form>` tag itself is emitted by `form_with`; this builder only owns the
# fields, so it composes independently of `Forms::Form`. Styling classes live on
# each control component (their `element_options`); the builder forwards the rest
# of the caller's options as `attrs:` (placeholder, required, autofocus, data, ...).
class ApplicationFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    field_options, attrs = split_options(options, :value, :type)
    control = @template.component "forms/text",
                                 name: field_name(attribute),
                                 value: attrs.delete(:value) || object_value(attribute),
                                 type: attrs.delete(:type) || "text",
                                 attrs: attrs
    wrap_field(attribute, field_options, control)
  end

  def text_area(attribute, options = {})
    field_options, attrs = split_options(options, :value)
    control = @template.component "forms/textarea",
                                 name: field_name(attribute),
                                 value: attrs.delete(:value) || object_value(attribute),
                                 attrs: attrs
    wrap_field(attribute, field_options, control)
  end

  def select(attribute, choices = nil, options = {}, html_options = {})
    field_options, attrs = split_options(options)
    control = @template.component "forms/select",
                                 name: field_name(attribute),
                                 options: choices,
                                 selected: object_value(attribute),
                                 attrs: attrs.merge(html_options)
    wrap_field(attribute, field_options, control)
  end

  # Matches Forms::Checkbox::Component's contract: a bare checkbox with value "1"
  # and a boolean `checked:` (no hidden unchecked twin, unlike Rails' check_box).
  def check_box(attribute, options = {})
    field_options, attrs = split_options(options, :checked_value, :unchecked_value)
    control = @template.component "forms/checkbox",
                                 name: field_name(attribute),
                                 checked: !!object_value(attribute),
                                 attrs: attrs
    wrap_field(attribute, field_options, control)
  end

  def radio_button(attribute, tag_value, options = {})
    field_options, attrs = split_options(options)
    control = @template.component "forms/radio",
                                 name: field_name(attribute),
                                 value: tag_value,
                                 checked: object_value(attribute) == tag_value,
                                 attrs: attrs
    wrap_field(attribute, field_options, control)
  end

  def toggle(attribute, options = {})
    field_options, attrs = split_options(options, :value)
    checked = attrs.delete(:value) || object_value(attribute)
    control = @template.component "forms/toggle",
                                 name: field_name(attribute),
                                 value: "1",
                                 checked: !!checked,
                                 attrs: attrs
    wrap_field(attribute, field_options, control)
  end

  # Method name differs from the Ruby keyword -- use `form.submit` as usual.
  def submit(value = "Save", options = {})
    @template.component "forms/submit", label: value, variant: options.fetch(:variant, :primary)
  end

  private

  # Split caller options into builder-level keys (label/error_message) and the
  # keys passed through to the control as `attrs`, removing the reserved control
  # keys (`value`, `type`, `unchecked_value`, ...) from both.
  def split_options(options, *reserved)
    options = options.dup
    field_options = {}
    { label: nil, error_message: nil }.each_key do |key|
      field_options[key] = options.delete(key) if options.key?(key)
    end
    reserved.each { |key| options.delete(key) }
    [ field_options, options ]
  end

  def wrap_field(attribute, options, control)
    label = options.delete(:label)
    return control if label == false

    @template.component "forms/field",
                        label: label,
                        error_message: options.delete(:error_message) || error_message_for(attribute) do
      control
    end
  end

  def field_name(attribute)
    "#{object_name}[#{attribute}]"
  end

  def object_value(attribute)
    return if object.nil?

    object.respond_to?(attribute) ? object.public_send(attribute) : nil
  end

  def error_message_for(attribute)
    return if object.nil? || !object.respond_to?(:errors)

    errors = object.errors[attribute] || []
    errors.first
  end
end
