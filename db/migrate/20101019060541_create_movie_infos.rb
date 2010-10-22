class CreateMovieInfos < ActiveRecord::Migration
  def self.up
    create_table :movie_infos do |t|
      t.string :name
      t.string :cover
      t.string :trailer
      t.string :imdb
      t.integer :year
      t.date :added
      t.integer :rating
      t.text :summary
      t.text :notes
      t.integer :movie_id
      t.integer :revision_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_infos
  end
end
