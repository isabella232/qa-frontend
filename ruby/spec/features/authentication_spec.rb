include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Creating a user", :type => :feature do

  before(:all) do
    @adminName = randomName
    @session = register_session(admin_credentials[:user], admin_credentials[:password])
    visit '/'
    login_with_valid_session(admin_credentials[:user], @session["session_id"])
  end

  it "should create admin user" do
    visit '/'
    find_link("System").click
    find_link("Authentication").click
    click_link_or_button("Add new user")

    find(:id, "username").set @adminName
    find(:id, "fullname").set "John Doe"
    find(:id, "email").set "test@example.org"
    find(:id, "password").set "123456"
    find(:id, "password-repeat").set "123456"
    within(:xpath, '//div[@class="form-group" and descendant::node()[text()="Roles"]]') do
      find(:css, "div.Select-control input").set "Admin"
    end
    click_button("Create User")
    expect(page).to have_link(@adminName)
  end

end