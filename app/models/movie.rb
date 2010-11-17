class Movie < ActiveRecord::Base
  validates :name, :presence => true
  
  before_update :make_change
  before_create :activate
  
  belongs_to :catalogue
  has_many :revisions
  
  attr_accessor :changed_by
  
  def inactivate
    revision = revisions.build(:change_type => "delete",
					 :catalogue_id => self.catalogue_id)
	revision.user = @changed_by
	active = false
	self.save
  end

  def diff(b)
    diff = {}
	self.attributes.each do |key, value|
		bvalue = b[key]
		unless value == bvalue or bvalue == nil
			diff[key] = [value,bvalue]
		end
	end
	return diff
  end
  
  def patch(diff)
	diff.each do |key, value|
		self[key] = value[1]
	end
  end
  
  def unpatch(diff)
	diff.each do |key, value|
		self[key] = value[0]
	end
  end
  
  private
  def make_change
	revision = revisions.build(:diff => self.changes,
					 :change_type => "update",
					 :catalogue_id => self.catalogue_id)
	revision.user = @changed_by
  end
  
  def activate
	revision = revisions.build(:change_type => "add",
					 :catalogue_id => self.catalogue_id)
	revision.user = @changed_by
  end
  
end
