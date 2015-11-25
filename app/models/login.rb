class Login < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :database => "ruby_development",
    :username => "necter",
    :password => "160504"
  )
#  attr_accessible :userid, :password, :password_confirmation
  attr_accessor :password
  before_save :encrypt_password

#  validates :userid, :password_salt, :password_hash, :kie, presence: true
  validates_confirmation_of :password

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

  def self.authenticate(userid, password)
    user = find_by_userid(userid)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    end
  end
end
