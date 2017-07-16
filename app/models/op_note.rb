class OpNote < ActiveRecord::Base
  validates_presence_of :surname, :forename, :cons_surg, :diagnosis, :operation, :surgeon1
  validates_presence_of :indication, :position, :incision, :findings, :proc_text, :ebl, :transfusion, :post_op

  validates_format_of :crn,
    :with => /^[0-9]{7}[A-Za-z]|[0-9]{10}$/,
    :message => 'must have seven digits followed by a letter or be a 10 digit CHI'

  validates_each :cons_anaes, :anaesthetist1 do |model, attr, value|
    if(model.anaesthetic =~ /General|Regional/ && value.blank?)
      model.errors.add(attr, "can't be blank for this type of anaesthetic")
    end
  end

  def crn=(unit_num)
    write_attribute("crn", unit_num.upcase)
  end
end
