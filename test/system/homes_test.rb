# frozen_string_literal: true

require 'application_system_test_case'

class HomesTest < ApplicationSystemTestCase
  test 'visiting the root' do
    visit root_url
    wait_for_stimulus_loading
    assert_selector 'h2', text: 'Welcome!'
  end
end
