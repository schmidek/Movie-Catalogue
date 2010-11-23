class CreateGenres < ActiveRecord::Migration
  def self.up
    create_table :genres do |t|
      t.string :name
    end
    create_table :genres_movies, :id => false do |t|
      t.integer :movie_id
      t.integer :genre_id
    end
  end

  def self.down
    drop_table :genres
    drop_table :genres_movies
  end
end
