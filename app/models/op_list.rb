class OpList < ActiveRecord::Base
  has_many(:op_list_entries, :order => "position", :dependent => :delete_all)
  belongs_to(:list_author, :polymorphic => true)
  
  validates_presence_of :theatre, :start_time, :surgeon
  
  def list_author_name=(name)
    self.list_author = GuestSurgeon.find(:first, :conditions => ["name = ?", name]) ||
      GuestSurgeon.new(:name => name)
  end
  
  def list_author_name
    self.list_author && self.list_author.name
  end
end
