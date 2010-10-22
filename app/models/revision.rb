class Revision < ActiveRecord::Base
  has_many :movie_infos
  belongs_to :catalogue
end
