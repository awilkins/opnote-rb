class OpListEntry < ActiveRecord::Base
  belongs_to(:op_list)
  acts_as_list(:scope => :op_list_id)

  validates_presence_of :dob, :surname, :forename, :sex, :ward, :operation

  validates_format_of :crn,
    :with => /^[0-9]{7}[A-Za-z]|[0-9]{10}$/,
    :message => 'must have seven digits followed by a letter or be a 10 digit CHI'

end
