class OpTemplate < ActiveRecord::Base
  validates_presence_of :surgeon, :operation
  validates_uniqueness_of :operation, :scope => 'surgeon'
end
