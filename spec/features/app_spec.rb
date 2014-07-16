require "spec_helper"

feature "Homepage" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_link("Link")
    expect(page).to have_content("Looking For Something?")
    expect(page).to have_button("Join")
  end

  feature "Registration" do
    scenario "A user can create an account and log in" do
      visit "/"

      click_link "Register"

      fill_in "Username", with: "huntanumba1"
      fill_in "Email", with: "hunter@example.com"
      fill_in "Password", with: "1234"
      check "I legally verify that my name is actually Hunter"

      click_button "Register"

      expect(page).to have_content "Thanks for signing up"
    end
  end


end #require end


