require 'test_helper'

class CatalogueTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "get all" do
    movies = Catalogue.find(1).all_movies
    assert_equal( movies.length, 1, "Number of movies for catalogue wrong")
    assert_equal( movies.first.name, "Shrek", "Name of first movie incorrect")
  end
end
