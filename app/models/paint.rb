class Paint < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :database => "ruby_development",
    :username => "necter",
    :password => "160504"
  )

validates :userid, :category, :filedata, :title, presence: true
end
