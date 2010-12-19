class User < ActiveRecord::Base
  acts_as_authentic
  belongs_to :catalogue
  has_and_belongs_to_many :roles
  
  def role_symbols
     (roles || []).map {|r| r.title.to_sym}
  end
  
end
