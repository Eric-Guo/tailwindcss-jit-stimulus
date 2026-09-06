require "application_system_test_case"

class HomesTest < ApplicationSystemTestCase
  test "visiting the root" do
    visit root_url
    assert_title "天华材料库"
    assert_selector "h2", text: "Welcome!"
    assert_selector "h1", text: "天华线上材料库"
    assert_field "搜索"
    assert_no_selector "#slideover-target"
  end

  test "expanding materials and stone reveals the third menu level" do
    open_sidebar
    assert_no_selector nav_target("nav2Container")
    assert_no_selector nav_target("nav3Container")

    click_nav "nav1Item", "材料 Materials"
    assert_selector nav_target("nav2Item"), text: "石材 Stone"
    assert_selector nav_target("nav2Item"), text: "玻璃 Glass"
    assert_no_selector nav_target("nav3Container")

    click_nav "nav2Item", "石材 Stone"
    assert_selector nav_target("nav2Item") + ".active", text: "石材 Stone"
    assert_selector nav_target("nav3Item"), text: "石灰石/青石 Limestone"
    assert_selector nav_target("nav3Item"), text: "大理石 Marble"
  end

  test "switching categories replaces children and clears deeper menus" do
    open_stone_menu
    click_nav "nav2Item", "玻璃 Glass"
    assert_selector nav_target("nav2Item") + ".active", text: "玻璃 Glass"
    assert_no_selector nav_target("nav2Item") + ".active", text: "石材 Stone"
    assert_selector nav_target("nav3Item"), text: "超白透明色玻璃基片"
    assert_selector nav_target("nav3Item"), text: "磨砂双星玻璃砖"
    assert_no_selector nav_target("nav3Item"), text: "Limestone"
    assert_no_selector nav_target("nav3Item"), text: "Marble"

    click_nav "nav1Item", "案例 Projects"
    assert_selector nav_target("nav1Item") + ".active", text: "案例 Projects"
    assert_no_selector nav_target("nav1Item") + ".active", text: "材料 Materials"
    assert_no_selector nav_target("nav2Container")
    assert_no_selector nav_target("nav3Container")

    click_nav "nav1Item", "材料 Materials"
    assert_selector nav_target("nav2Item"), text: "石材 Stone"
    assert_no_selector nav_target("nav3Container")
  end

  test "closing and reopening the sidebar resets the submenu panels" do
    open_stone_menu
    find('button[aria-label="Close sidebar"]').click
    assert_no_selector "#slideover-target"
    assert_no_selector '[data-slideover-target="overlay"]'

    find('header [data-action="click->slideover#toggle"]').click
    assert_selector "#slideover-target"
    assert_no_selector nav_target("nav2Container")
    assert_no_selector nav_target("nav3Container")
    click_nav "nav1Item", "材料 Materials"
    click_nav "nav2Item", "石材 Stone"
    assert_selector nav_target("nav3Item"), text: "大理石 Marble"
  end

  private

  def nav_target(name)
    "#slideover-target [data-sidebar-nav-target='#{name}']"
  end

  def click_nav(level, text)
    wait_for_sidebar_animation
    find(nav_target(level), text: text).click
  end

  def wait_for_sidebar_animation
    # Visible elements can still move under the pointer during slide transitions.
    assert_selector "#slideover-target" do |menu|
      menu.evaluate_script('this.getAnimations({ subtree: true }).every(animation => animation.playState === "finished")')
    end
  end

  def open_sidebar
    visit root_url
    wait_for_stimulus_loading
    # The slideover controller schedules an initial hide on connect. Let it finish
    # before opening, otherwise that pending callback hides the newly opened menu.
    page.evaluate_async_script(<<~JS)
      const done = arguments[0];
      const sidebar = document.querySelector('[data-controller="slideover"]');
      const timeout = Number(sidebar.dataset.slideoverLeaveTimeout.split(',')[0]);
      setTimeout(done, timeout + 50);
    JS
    find('header [data-action="click->slideover#toggle"]').click
    assert_selector "#slideover-target"
    assert_selector 'button[aria-label="Close sidebar"]'
    wait_for_sidebar_animation
  end

  def open_stone_menu
    open_sidebar
    click_nav "nav1Item", "材料 Materials"
    click_nav "nav2Item", "石材 Stone"
    assert_selector nav_target("nav3Item"), text: "大理石 Marble"
  end
end
