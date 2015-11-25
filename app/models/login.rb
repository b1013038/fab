class Login < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :database => "ruby_development",
    :username => "necter",
    :password => "160504"
  )
#  attr_accessible :userid, :password, :password_confirmation
  attr_accessor :password, :password_confirmation
  before_save :encrypt_password
  #validates :userid, presence: true
  validates :userid, length: { in: 4..10 }
#  validates :password, length: { in: 4..10 }

  validates_confirmation_of :password, :password_confirmation

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
