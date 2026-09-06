require "test_helper"

class HomeTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
    assert_select "title", "天华材料库"
    assert_select "h1", "天华线上材料库"
    assert_select 'header [data-action="click->slideover#toggle"]', count: 1
    assert_select "#slideover-target.hidden", count: 1
    assert_select '[data-sidebar-nav-target="nav1Item"]', count: 4
  end

  test 'should get phone index' do
    get root_url, headers: {
      "HTTP_USER_AGENT" => "Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 Version/17.0 Mobile/15E148 Safari/604.1"
    }
    assert_response :success
    assert_select "h1", "天华线上材料库"
    assert_select "h2", "Welcome!"
    assert_select "header img", count: 1
    assert_select 'header [data-action="click->slideover#toggle"]', count: 0
  end
end
