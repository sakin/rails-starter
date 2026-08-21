# frozen_string_literal: true

# Abstract base for every view component in the app. Never renders itself.
#
# `ViewComponentContrib::Base` already wires in:
#   - component-scoped i18n via `t(".key")` -> `en.view_components.<scope>`;
#   - the `#wrapped` helper for container wrappers.
# `Dry::Initializer` gives declarative arguments (`option :title`).
# `DbQueryGuard` makes stray database queries raise during rendering.
# `StyleVariants` gives a declarative `style do ... end` DSL for class variants.
#
# Every component accepts the common root arguments `attrs`, `class`, `id`, and
# `data`, merged by `#options` into one element-attribute hash for the root tag:
#   - `class`: caller's root `class` + `attrs[:class]` are joined over the
#     defaults and Tailwind-merged (caller wins); daisyUI classes are preserved.
#   - `data`: caller's `data` + `attrs[:data]` deep-merge over the defaults.
#   - `id`: `id` overrides `attrs[:id]` (sugar, not merged).
#   - everything else in `attrs` passes through as-is.
# A caller merges first, so any `attrs[:class]` beat the component defaults.
class ApplicationViewComponent < ViewComponentContrib::Base
  extend Dry::Initializer

  include DbQueryGuard
  include ComponentsHelper
  include ViewComponentContrib::StyleVariants

  # References the Ruby class, not the `class:` argument -- the option keeps the
  # keyword while the reader is exposed as `css_class` so `component.class` and
  # other Object#class callers are unaffected.
  option :attrs, default: proc { {} }
  option :class, as: :css_class, default: proc { nil }
  option :id, default: proc { nil }
  option :data, default: proc { {} }

  # Merge the component's own element defaults with the caller's root arguments
  # into one attribute hash a template can pass to `tag.attributes(**...)`.
  #
  # The essentials passed as `defaults` (e.g. a control's `name`) win over any
  # `attrs` supplied for the same key, while non-essential caller `attrs` fill in
  # the rest as pass-through. Caller classes/data merge over the component's.
  def element_options(defaults = {})
    merged = attrs.except(:class, :id, :data).merge(defaults.deep_dup)
    merged[:class] = merge_classes(defaults[:class], css_class, attrs[:class])
    merged.delete(:class) if merged[:class].empty?
    merged[:data] = merge_data(defaults[:data], attrs[:data], data)
    merged[:id] = id.presence || attrs[:id]
    merged.delete(:id) if merged[:id].blank?
    merged
  end

  # Stimulus identifier for this component's controller: `Banner::Badge::Component`
  # -> `banner--badge`.
  def controller_name
    @controller_name ||= self.class.name.sub("::Component", "").underscore.tr("_", "-").split("/").join("--")
  end

  # A scoped CSS class token so component styles never collide across folders.
  def class_for(token)
    "c-#{controller_name}-#{token}"
  end

  # Reconcile conflicting utility classes emitted by `style do ... end` so a
  # caller-supplied later class wins over a component default (daisyUI classes
  # are preserved, not merged, by tailwind_merge).
  style_config.postprocess_with do |classes|
    TailwindMerge::Merger.new.merge(classes.join(" "))
  end

  private

  def merge_classes(*lists)
    classes = lists.compact.map(&:strip).reject(&:empty?).join(" ")
    return "" if classes.empty?

    TailwindMerge::Merger.new.merge(classes)
  end

  def merge_data(*hashes)
    hashes.compact.reduce({}) do |acc, hash|
      acc.deep_merge(hash)
    end
  end
end
