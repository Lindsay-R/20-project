require "spec_helper"

  feature "Basics: homepage, join, signin" do
    scenario "check homepage" do
      visit "/"
      expect(page).to have_link("Link")
      expect(page).to have_content("Looking For Typography Inspiration?")
      expect(page).to have_link("Join")
      expect(page).to have_link("SignIn")
      expect(page).to have_button("Search")
    end

    scenario "A user can Join" do
      visit "/"
      click_link "Join"
      fill_in "Email", with: "lindsay@example.com"
      fill_in "Username", with: "lindsay"
      fill_in "Create Password", with: "123"
      click_button "Join"
      expect(page).to have_content "Lindsay"
    end

    scenario "A user can SignIn from homepage" do
      visit "/"
      click_link "SignIn"
      fill_in "Email", with: "lindsay@example.com"
      fill_in "Password", with: "123"
      click_button "SignIn"
      expect(page).to have_content "Lindsay"
    end

end #feature end


feature "Basics: Userpage" do
  scenario "check userpage" do
    visit "/"
    click_link "SignIn"
    fill_in "Email", with: "lindsay@example.com"
    fill_in "Password", with: "123"
    click_button "SignIn"
    expect(page).to have_link("Link")
    expect(page).to have_content "Lindsay"
    expect(page).to have_button("Search")
  end

end #feature end

