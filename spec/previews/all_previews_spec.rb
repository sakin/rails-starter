# frozen_string_literal: true

# Every Lookbook preview example must render without error. The individual
# component specs cover their own markup; this guards the preview/Lookbook
# surface itself so a broken or blank preview can't slip through (as the
# `Forms::Preview#builder` scene did).
RSpec.describe("Lookbook previews", type: :view_component) do
  # Previews live under the `app/views/components` autoload root; load them all
  # up front so the dynamic examples below cover every preview class. Skip the
  # abstract application base.
  Rails.application.eager_load!

  preview_classes = ViewComponent::Preview.all.reject(&:abstract_class?)
  preview_classes.each do |preview_class|
    preview_class.examples.sort.each do |example|
      it "#{preview_class.preview_name}.#{example} renders" do
        html = render_preview(example, from: preview_class)
        expect(html.to_s).not_to be_empty
      end
    end
  end
end
