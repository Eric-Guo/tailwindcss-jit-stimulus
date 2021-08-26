require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the root" do
    visit root_url

    assert_selector "h1", text: "Hello, Stimulus!"
  end
end
