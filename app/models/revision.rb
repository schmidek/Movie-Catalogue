class Revision < ActiveRecord::Base
  has_many :movies
  belongs_to :catalogue
end
