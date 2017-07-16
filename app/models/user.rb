require 'digest/sha2'

class User < ActiveRecord::Base
  validates_uniqueness_of :username

  def password=(pass)
    salt = [Array.new(6){rand(256).chr}.join].pack("m").chomp
    self.password_salt, self.password_hash = salt, Digest::SHA256.hexdigest(pass + salt)
  end
  
  def test_password(pass)
    test_hash = Digest::SHA256.hexdigest(pass + self.password_salt)
    self.password_hash == test_hash
  end
end
