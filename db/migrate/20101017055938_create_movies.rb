class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.integer :catalogue_id
      t.integer :movie_info_id

      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
