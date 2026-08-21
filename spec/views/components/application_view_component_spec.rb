# frozen_string_literal: true

# A tiny concrete component exercising the base attribute contract.
module SampleAttrs
  class Component < ApplicationViewComponent
  end
end

RSpec.describe(ApplicationViewComponent, type: :view_component) do
  subject(:component) { SampleAttrs::Component.new(**constructor_args) }

  let(:constructor_args) { {} }

  describe "#attrs" do
    it "defaults to an empty hash" do
      expect(component.attrs).to eq({})
    end
  end

  describe "#element_options" do
    context "with a root data arg" do
      let(:constructor_args) { { data: { foo: "baz" } } }

      it "deep-merges caller data over component defaults" do
        merged = component.element_options(class: "c-x", data: { controller: "sample-attrs", foo: "bar" })

        expect(merged[:data]).to eq(controller: "sample-attrs", foo: "baz")
      end
    end

    context "with a root class arg over attrs class" do
      let(:constructor_args) { { class: "btn-outline", attrs: { class: "p-8", data: { controller: "c" } }, data: { action: "x" } } }

      it "joins caller class and attrs class over the component default class" do
        merged = component.element_options(class: "btn")

        expect(merged[:class]).to eq("btn btn-outline p-8")
        expect(merged[:data]).to eq(action: "x", controller: "c")
      end
    end

    context "with id and extra attrs" do
      let(:constructor_args) { { id: "email", attrs: { required: true } } }

      it "passes them through" do
        merged = component.element_options({})

        expect(merged[:id]).to eq("email")
        expect(merged[:required]).to be(true)
      end
    end

    it "keeps component-internal data when caller data omits it" do
      constructor_args_override = { data: { foo: "baz" } }
      merged = SampleAttrs::Component.new(**constructor_args_override).element_options(
        data: { controller: "sample-attrs" }
      )

      expect(merged[:data]).to eq(controller: "sample-attrs", foo: "baz")
    end
  end
end
