require "application_system_test_case"

class SitesTest < ApplicationSystemTestCase
  setup do
    @site = sites(:one)
  end

  test "visiting the index" do
    visit sites_url
    assert_selector "h1", text: "Sites"
  end

  test "should create Site" do
    visit sites_url
    click_on "New Site"

    fill_in "Installation", with: @site.installation_id
    fill_in "Repo", with: @site.repo
    click_on "Create Site"

    assert_text "Site was successfully created"
    click_on "Back"
  end

  test "should update Site" do
    visit sites_url
    click_on "Edit", match: :first

    fill_in "Installation", with: @site.installation_id
    fill_in "Repo", with: @site.repo
    click_on "Update Site"

    assert_text "Site was successfully updated"
    click_on "Back"
  end

  test "should destroy Site" do
    visit sites_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Site was successfully destroyed"
  end
end
