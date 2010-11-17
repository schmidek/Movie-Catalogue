class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.string :name
      t.string :cover
      t.string :trailer
      t.string :imdb
      t.integer :year
      t.date :added
      t.integer :rating
      t.text :summary
      t.text :notes
      t.integer :catalogue_id
      t.boolean :active, :null => false, :default => true

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
