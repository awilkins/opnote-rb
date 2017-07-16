class Anaesthetist < ActiveRecord::Base
  def name
    read_attribute(:surname) << ' ' << read_attribute(:initials)
  end
end
