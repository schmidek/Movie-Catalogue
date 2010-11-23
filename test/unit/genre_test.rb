require 'test_helper'

class GenreTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "get ids" do
    names = ["Comedy"]
    ids = Genre.get_ids(names)
    dbgenre = Genre.find_by_name("Comedy")
    assert_equal(1, ids.length)
    assert_equal(dbgenre.id, ids[0])
  end
end
