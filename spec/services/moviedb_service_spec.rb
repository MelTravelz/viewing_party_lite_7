require 'rails_helper'

RSpec.describe MoviedbService do
  describe "instance methods" do 
    context "#fetch_api" do
      it "returns json object" do
        top_movies = File.read("spec/fixtures/moviedb/top_movies.json")
        stub_request(:get, "https://api.themoviedb.org/movie/top_rated?api_key=#{ENV["TMDB_API_KEY"]}&include_adult=false")
        .to_return(status: 200, body: top_movies, headers: {})

        expect(MoviedbService.new.fetch_api("/movie/top_rated?include_adult=false")).to be_a(Hash)
        # SHOULD test for keys the Hash being returned!!! 
        #Then change the fixture to call each "get" method in the service and call a unique key from that API call
      end
    end
  end
end