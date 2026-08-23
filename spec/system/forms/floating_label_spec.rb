# frozen_string_literal: true

# Browser test that daisyUI's `floating-label` actually floats the span on
# focus/value. daisyUI does this in CSS (via `:focus-within` / placeholder-shown),
# so we assert the real float (the span's computed `opacity`) rather than a
# JS-driven class — which was the mistake that hid the earlier stale-class bug.
RSpec.describe "Floating label", type: :system do
  def span_opacity(wrapper)
    wrapper.evaluate_script("getComputedStyle(this.querySelector('span')).opacity").to_f
  end

  def floating?(wrapper)
    span_opacity(wrapper) > 0.1
  end

  def wait_until(seconds)
    deadline = Time.now + seconds
    until yield
      expect(Time.now).to be < deadline
      sleep 0.05
    end
  end

  it "floats the label on value and rests when emptied and blurred" do
    visit "/session/new"

    field = find("input[name='email_address']")
    wrapper = field.find(:xpath, "ancestor::label[1]")

    field.fill_in(with: "you@example.com")
    expect(wrapper).to satisfy { floating?(_1) }

    field.fill_in(with: "")
    field.evaluate_script("this.blur()")
    # daisyUI animates the float, so wait until the resting opacity settles.
    wait_until(2) { !floating?(wrapper) }
  end

  it "floats an empty field while focused" do
    visit "/session/new"

    field = find("input[name='email_address']")
    wrapper = field.find(:xpath, "ancestor::label[1]")

    field.click
    expect(wrapper).to satisfy { floating?(_1) }
  end
end
