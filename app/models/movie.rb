class Movie < ActiveRecord::Base
  validates :name, :presence => true
  validates_inclusion_of :format, :in => %w(Bluray DVD)
  
  before_update :make_change
  before_create :activate
  
  belongs_to :catalogue
  has_many :revisions, :dependent => :destroy, :readonly => true
  has_and_belongs_to_many :genres
  
  attr_accessor :changed_by
  
  #TODO bad performance
  def as_json(options)
	{:movie => super(options).attributes.merge(:genres => genre_names) }
  end
  
  def inactivate
    revision = revisions.build(:change_type => "delete",
					 :catalogue_id => self.catalogue_id)
	revision.user = @changed_by
	active = false
	save
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
  
  def genre_names
	genres.collect {|g| g.name }
  end
  
  private
  def make_change
	revision = revisions.build(:diff => self.changes.to_json,
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
