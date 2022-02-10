require "rails_helper"

RSpec.describe "User roles page", type: :feature do
  before do
    @user = create(:user, admin: false)
    @admin_user = create(:user, admin: true)
    sign_in @admin_user
  end

  it "has an admin checkbox for every user" do
    visit users_roles_path
    expect(page.find("input#user-admin-#{@user.id}")).not_to be_checked
    expect(page.find("input#user-admin-#{@admin_user.id}")).to be_checked
  end

  it "Checkboxes change admin role", js: true do
    visit users_roles_path
    expect(page.find("input#user-admin-#{@user.id}")).not_to be_checked
    page.check("user-admin-#{@user.id}")
    visit users_roles_path
    expect(page.find("input#user-admin-#{@user.id}")).to be_checked
  end
end
