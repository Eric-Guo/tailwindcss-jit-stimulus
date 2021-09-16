require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]

  def wait_for_stimulus_loading
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_stimulus_loading?
    end
  end

  def finished_all_stimulus_loading?
    !page.evaluate_script('Stimulus.controllers.length').zero?
  end
end
