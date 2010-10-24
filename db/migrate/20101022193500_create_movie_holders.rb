class CreateMovieHolders < ActiveRecord::Migration
  def self.up
    create_table :movie_holders do |t|
      t.integer :catalogue_id
      t.integer :movie_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movie_holders
  end
end
