require 'rails_helper'

RSpec.describe "/", type: :feature do
  describe "as a user, when I visit the log in form page" do 
    before :each do
      @riker = User.create!(name: "William Riker", email: "number2@uss-enterprise.com", password: "IamNumber2")
      visit "/login"
    end

    describe "happy path tests" do
      it "can log in with valid credentials, when I click Log In & am taken to my Dashboard page" do      
        fill_in('Email', with: "number2@uss-enterprise.com")
        fill_in("Password:", with: "IamNumber2")

        click_on("Log In")

        expect(current_path).to eq("/dashboard")
        expect(page).to have_content("Welcome, William Riker!")
      end
    end

    describe "sad path tests" do
      it "can NOT log in with invalid password & am redirected back to the login form page" do  
        fill_in('Email', with: "number2@uss-enterprise.com")
        fill_in("Password:", with: "wrong password")

        click_on("Log In")

        expect(current_path).to eq("/login")
        # expect(current_path).to eq(login_path)
        expect(page).to have_content("Sorry, your password is incorrect.")
      end

      it "can NOT log in with nil password & am redirected back to the login form page" do  
        fill_in('Email', with: "number2@uss-enterprise.com")
        fill_in("Password:", with: nil)

        click_on("Log In")

        expect(current_path).to eq("/login")
        # expect(current_path).to eq(login_path)
        expect(page).to have_content("Sorry, your password is incorrect.")
      end

      it "can NOT log in with invalid email & am redirected back to the login form page" do  
        fill_in('Email', with: "WRONG@uss-enterprise.com")
        fill_in("Password:", with: "IamNumber2")

        click_on("Log In")

        expect(current_path).to eq("/login")
        # expect(current_path).to eq(login_path)
        expect(page).to have_content("Sorry, your email is incorrect.")
      end

      it "can NOT log in with nil email & am redirected back to the login form page" do  
        fill_in('Email', with: nil)
        fill_in("Password:", with: "IamNumber2")

        click_on("Log In")

        expect(current_path).to eq("/login")
        # expect(current_path).to eq(login_path)
        expect(page).to have_content("Sorry, your email is incorrect.")
      end
    end
  end
end