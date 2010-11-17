class Revision < ActiveRecord::Base
	validates_inclusion_of :change_type, :in => %w(add update delete)
	belongs_to :catalogue
	belongs_to :movie
	belongs_to :user
end
