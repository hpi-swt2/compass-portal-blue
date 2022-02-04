require "rails_helper"

RSpec.describe "User roles page", type: :feature do
  before do
    @user = create(:user, admin: false)
  end

  it "has an admin checkbox for every user" do
    admin_user = create(:user, admin: true)
    sign_in admin_user
    visit users_roles_path
    expect(page.find("input#user-admin-#{@user.id}")).not_to be_checked
    expect(page.find("input#user-admin-#{admin_user.id}")).to be_checked
  end

  it "Checkboxes change admin role", js: true do
    admin_user = create(:user, admin: true)
    sign_in admin_user
    visit users_roles_path
    expect(@user.admin).to be(false)
    page.find("input#user-admin-#{@user.id}").click
    expect(@user.admin).to be(true)
  end

end
