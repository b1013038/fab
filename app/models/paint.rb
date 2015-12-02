class Paint < ActiveRecord::Base
  establish_connection(
    :adapter  => "mysql2",
    :database => "ruby_development",
    :username => "necter",
    :password => "160504"
  )

validates :userid, :category, :filedata, :title, presence: true

 # validates :userid, length: { in: 3..10 }
 # validates :title, length: { in: 1..15 }
end
