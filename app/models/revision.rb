class Revision < ActiveRecord::Base
	validates_inclusion_of :change_type, :in => %w(add update delete)
	belongs_to :catalogue
	belongs_to :movie
	belongs_to :user
	
	def format_diff(format)
		str = ''
		unless diff.nil?
			hash = JSON.parse(diff)
			str = ''
			hash.each do |key,value|
				str += '<b>' + key.capitalize + '</b>: '
				str += Differ.parse(:array,value).format_as(format)
				str += '<br />'
			end
		end
		return str
	end
	
end
