require 'rails_helper'

RSpec.describe "/users/:user_id/movies/:movie_id" do
  describe "as a user, when I visit a movie's show page" do 
    before :each do
      @picard = User.create!(name: "Jean-Luc Picard", email: "captain@uss-enterprise.com", password: "IamCaptain!")

      movie_response = File.read("spec/fixtures/moviedb/space_odyssey.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: movie_response, headers: {})
        
      cast_response = File.read("spec/fixtures/moviedb/space_cast.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62/credits?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: cast_response, headers: {})

      reviews_response = File.read("spec/fixtures/moviedb/space_reviews.json")
      stub_request(:get, "https://api.themoviedb.org/3/movie/62/reviews?api_key=#{ENV["TMDB_API_KEY"]}")
      .to_return(status: 200, body: reviews_response, headers: {})
    end

    it "displays the movie information" do
      visit "/users/#{@picard.id}/movies/62"

      expect(page).to have_content("2001: A Space Odyssey")

      expect(page).to have_button("Discover Page")
      expect(page).to have_button("Create Viewing Party for 2001: A Space Odyssey")
      expect(page).to have_content("Vote: 8.083")
      expect(page).to have_content("Runtime: 2 hrs 29 mins")
      expect(page).to have_content("Genre:")
      expect(page).to have_content("Science Fiction")
      expect(page).to have_content("Mystery")
      expect(page).to have_content("Adventure")

      expect(page).to have_content("Summary")
      expect(page).to have_content("Humanity finds a mysterious object buried beneath the lunar surface and sets off to find its origins with the help of HAL 9000, the world's most advanced super computer.")

      expect(page).to have_content("Cast")
      # Not sure if I need to test for all 10 actors? 
      expect(page).to have_content("Keir Dullea as Dr. David Bowman")
      expect(page).to have_content("Frank Miller as Mission Controller")

      expect(page).to have_content("7 Reviews")
      # This text is very long, so decided to only test for part of it:
        # expect(page).to have_content("markuspm: There are many great predictions hinting to future (it is from 1968 
        #   - can you believe it?) innovations throughout the movie. I might not have found all them because I keep 
        #   falling asleep while watching it but I will keep trying to find them all.")
      expect(page).to have_content("markuspm: There are many great predictions hinting to future")
    end

    it "when I click the discover button, I'm redirected to '/users/:id/discover' page" do
      visit "/users/#{@picard.id}/movies/62"

      click_button("Discover Page")
      expect(current_path).to eq("/users/#{@picard.id}/discover")
    end

    it "when NOT logged in, click the Create Viewing Party button, I'm redirected back to the movie show page w/ error message" do
      visit "/users/#{@picard.id}/movies/62"
      
      click_button("Create Viewing Party for 2001: A Space Odyssey")
      expect(current_path).to eq("/users/#{@picard.id}/movies/62")
      expect(page).to have_content("You must be logged in or registered to continue.")
    end

    it "when logged in, click the Create Viewing Party button, I'm taken to the viewing party new form page" do
      log_in(@picard)
      visit "/users/#{@picard.id}/movies/62"

      click_button("Create Viewing Party for 2001: A Space Odyssey")
      expect(current_path).to eq("/users/#{@picard.id}/movies/62/viewing_party/new")
    end

    # Original Test:
    # it "when I click the Create Viewing Party button, I'm redirected to '/users/:id/movies/:id/viewing-party/new' page" do
    #   visit "/users/#{@picard.id}/movies/62"

    #   click_button("Create Viewing Party for 2001: A Space Odyssey")
    #   expect(current_path).to eq("/users/#{@picard.id}/movies/62/viewing_party/new")
    # end
  end
end