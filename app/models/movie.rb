class Movie < ActiveRecord::Base
  using_access_control
  validates :name, :presence => true
  validates_inclusion_of :format, :in => %w(Bluray DVD)
  
  before_update :make_change
  before_create :activate
  
  belongs_to :catalogue
  has_many :revisions, :dependent => :destroy, :readonly => true
  has_and_belongs_to_many :genres
  
  keep_track_of :genres
  
  #TODO bad performance
  def as_json(options)
	{:movie => super(options).attributes.merge(:genres => genre_names) }
  end
  
  def inactivate
    revision = revisions.build(:change_type => "delete",
					 :catalogue_id => self.catalogue_id)
	revision.user = Authorization.current_user
	self.active = false
	if is_s3_url?(cover)
		uuid = self.cover.split("/")[-1]
		AWS::S3::S3Object.delete(uuid, S3_CREDENTIALS['bucket'])
		self.cover = ""
	end
	save
  end

  def diff
    diff = {}
	self.changes.each do |key, value|
		if key == 'active'
			next
		end
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
  
  def upload_image
    if (cover =~ URI::regexp).nil?
		return
	end
	arr = Magick::Image.read(cover)
	if arr.count <= 0
		return
	end
	img = arr[0]
	img.format = "JPG"
	if (img.columns > 200 or img.rows > 280)
		img.resize_to_fit!(200,280)
	end
	uuid = UUIDTools::UUID::random_create.to_s
	AWS::S3::S3Object.store(uuid, img.to_blob, S3_CREDENTIALS['bucket'], :content_type => 'image/jpeg', :access => :public_read)
	self.cover = public_s3_url(uuid)
  end
  
  def public_s3_url(filename)
	"#{S3_CREDENTIALS['prefix']}/#{filename}"
  end
  
  def is_s3_url?(url)
	(not url.nil?) and url.starts_with?(S3_CREDENTIALS['prefix'])
  end
  
private
  def make_change
    if (not diff.empty?)
	  if self.changes.has_key?("cover")
		oldcover = self.changes["cover"][0]
		if is_s3_url?(oldcover)
			uuid = oldcover.split("/")[-1]
			AWS::S3::S3Object.delete(uuid, S3_CREDENTIALS['bucket'])
		end
		upload_image()
	  end
	  revision = revisions.build(:diff => diff.to_json,
								 :change_type => "update",
								 :catalogue_id => self.catalogue_id)
	  revision.user = Authorization.current_user
	end
  end
  
  def activate
	revision = revisions.build(:change_type => "add",
					 :catalogue_id => self.catalogue_id)
	revision.user = Authorization.current_user
	upload_image()
  end
  
end
