class Movie < ActiveRecord::Base
  validates :name, :presence => true
  validates_inclusion_of :format, :in => %w(Bluray DVD)
  
  before_update :make_change
  before_create :activate
  
  belongs_to :catalogue
  has_many :revisions, :dependent => :destroy, :readonly => true
  has_and_belongs_to_many :genres
  
  keep_track_of :genres
  
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

  def diff
    diff = {}
	self.changes.each do |key, value|
		a = value[0].to_s || ''
		b = value[1].to_s || ''
		#find shortest diff method
		diff1 = Differ.diff_by_char(b,a).format_as(:array)
		diff2 = Differ.diff_by_word(b,a).format_as(:array)
		diff3 = Differ.diff_by_line(b,a).format_as(:array)
		d = [diff1, diff2, diff3].min { |d1,d2| d1.to_json.length <=> d2.to_json.length }
		
		diff[key] = d
	end
	if respond_to?('genre_ids_changed?') and genre_ids_changed?
		oldgenres = genres_were.collect {|g| g.name }.sort.join(" ")
		newgenres = genre_names.sort.join(" ")
		diff["genres"] = Differ.diff_by_word(newgenres,oldgenres).format_as(:array)
	end
	return diff
  end
  
  #TODO fix for new diff
  def patch(diff)
	diff.each do |key, value|
		self[key] = value[1]
	end
  end
  
  #TODO fix for new diff
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
	revision = revisions.build(:diff => diff.to_json,
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
