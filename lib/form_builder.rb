# frozen_string_literal: true

# A Rails form builder that maps field methods to the `forms/*` view-component
# family. Each field method composes a `Forms::Field` wrapper around a typed
# control component, so `form.text_field :email, label: "Email address"` renders
# a proper labelled control in one call. Pass it with `form_with builder: FormBuilder`.
#
# The `<form>` tag itself is emitted by `form_with`; this builder only owns the
# fields, so it composes independently of `Forms::Form`.
class FormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    field_options, input_html = split_options(options, :value, :type)
    control = @template.component "forms/text",
                                 name: field_name(attribute),
                                 value: input_html.delete(:value) || object_value(attribute),
                                 type: input_html.delete(:type) || "text",
                                 input_html: { class: "input input-bordered w-full" }.merge(input_html)
    wrap_field(attribute, field_options, control)
  end

  def text_area(attribute, options = {})
    field_options, input_html = split_options(options, :value)
    control = @template.component "forms/textarea",
                                 name: field_name(attribute),
                                 value: input_html.delete(:value) || object_value(attribute),
                                 input_html: { class: "textarea textarea-bordered w-full" }.merge(input_html)
    wrap_field(attribute, field_options, control)
  end

  def select(attribute, choices = nil, options = {}, html_options = {})
    field_options, = split_options(options)
    control = @template.component "forms/select",
                                 name: field_name(attribute),
                                 options: choices,
                                 selected: object_value(attribute),
                                 input_html: { class: "select select-bordered w-full" }.merge(html_options)
    wrap_field(attribute, field_options, control)
  end

  def check_box(attribute, options = {}, checked_value = "1", unchecked_value = "0")
    field_options, input_html = split_options(options)
    control = @template.component "forms/checkbox",
                                 name: field_name(attribute),
                                 checked: object_value(attribute) == checked_value,
                                 input_html: { class: "checkbox" }.merge(input_html)
    wrap_field(attribute, field_options, control)
  end

  def radio_button(attribute, tag_value, options = {})
    field_options, input_html = split_options(options)
    control = @template.component "forms/radio",
                                 name: field_name(attribute),
                                 value: tag_value,
                                 checked: object_value(attribute) == tag_value,
                                 input_html: { class: "radio" }.merge(input_html)
    wrap_field(attribute, field_options, control)
  end

  def toggle(attribute, options = {})
    field_options, input_html = split_options(options, :value)
    checked = input_html.delete(:value) || object_value(attribute)
    control = @template.component "forms/toggle",
                                 name: field_name(attribute),
                                 value: "1",
                                 checked: !!checked,
                                 input_html: { class: "toggle" }.merge(input_html)
    wrap_field(attribute, field_options, control)
  end

  # Method name differs from the Ruby keyword -- use `form.submit` as usual.
  def submit(value = "Save", _options = {})
    @template.component "forms/submit", label: value
  end

  private

  # Split caller options into builder-level keys (label/error_message) and the
  # keys that belong on the control's HTML attributes, removing the reserved
  # control keys (`value`, `type`, ...) from both.
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
