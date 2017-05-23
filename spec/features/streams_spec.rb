include RSpec::Expectations
include SessionHelpers
include GenericHelpers

describe "Creating a stream", :type => :feature do
  include_examples "authenticated"

  before(:all) do
    @streamName = randomName
  end

  before(:each) do
    visit "/streams"
  end

  it "should create stream" do
    click_button("Create Stream")

    within(modal_dialog) do
      fill_in(name: "Title", with: @streamName)
      fill_in(name: "Description", with: "Testing")
      click_on("Save")
    end
    expect(page).to match have_link(@streamName)
    expect(page).to have_text("Stopped")
    expect(page).to have_content("Testing")
  end

  it "should add stream rule" do
    within(find_stream(@streamName)) do
      click_on("Manage Rules")
    end
    click_on("Add stream rule")

    within(modal_dialog) do
      fill_in("Field", class: "tt-input", with: "message")
      fill_in(name: "Value", with: "foo")
      click_on("Save")
    end

    within(find_stream(@streamName)) do
      expect(streamrules_list).to have_text("Field message must match exactly foo")
    end
  end

  it "should start the stream" do
    within(find_stream(@streamName)) do
      click_on "Start Stream"
    end

    expect(find_stream(@streamName)).to have_no_content("Stopped")
  end

  it "should pause the stream" do
    within(find_stream(@streamName)) do
      accept_alert("Do you really want to pause stream '#{@streamName}'?") do
        click_on "Pause Stream"
      end
    end

    expect(find_stream(@streamName)).to have_content("Stopped")
  end

  it "should delete the stream" do
    within(find_stream(@streamName)) do
      click_button("More Actions")
      accept_alert "Do you really want to remove this stream" do
        click_link("Delete this stream")
      end
    end
    expect(page).to have_no_link(@streamName)
  end

  def find_stream(streamName, options = {})
    find("li", class: "stream", text: streamName)
  end

  def modal_dialog
    find("div", class: "modal")
  end

  def streamrules_list
    find("ul", class: "streamrules-list")
  end
end