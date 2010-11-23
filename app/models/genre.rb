class Genre < ActiveRecord::Base
	has_and_belongs_to_many :movies
	
	def self.get_ids(names)
		dbgenres = all.to_a
		ids = Array.new
		names.uniq.each do |name|
			genre = dbgenres.find { |g| g.name == name }
			unless genre == nil
				ids.push genre.id
			end
		end
		return ids
	end
	
end
