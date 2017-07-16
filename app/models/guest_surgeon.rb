class GuestSurgeon < ActiveRecord::Base
  has_many(:op_lists, :as => :list_author)
end
