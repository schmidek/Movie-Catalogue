class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :name, :null => false
      t.string :cover
      t.string :trailer
      t.string :imdb
      t.integer :year
      t.datetime :added
      t.integer :rating
      t.string :format, :default => "Bluray"
      t.text :summary
      t.text :notes
      t.integer :catalogue_id
      t.boolean :active, :null => false, :default => true
    end
  end

  def self.down
    drop_table :movies
  end
end
