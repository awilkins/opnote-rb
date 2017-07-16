class InitialSchema < ActiveRecord::Migration
  def self.up
    
    create_table "op_list_entries", :force => true do |t|
      t.column "op_list_id", :integer, :null => false
      t.column "updated_at", :timestamp, :null => false
      t.column "position", :integer, :null => false
      t.column "crn", :text, :null => false
      t.column "dob", :date, :null => false
      t.column "surname", :text, :null => false
      t.column "forename", :text, :null => false
      t.column "sex", :text, :null => false
      t.column "ward", :text, :null => false
      t.column "operation", :text, :null => false
      t.column "notes", :text
    end

    create_table "op_lists", :force => true do |t|
      t.column "updated_at", :timestamp, :null => false
      t.column "theatre", :text, :null => false
      t.column "start_time", :timestamp, :null => false
      t.column "surgeon", :text, :null => false
      t.column "anaesthetist", :text
    end

    create_table "op_notes", :force => true do |t|
      t.column "created_at", :timestamp, :null => false
      t.column "updated_at", :timestamp, :null => false
      t.column "crn", :text, :null => false
      t.column "dob", :date, :null => false
      t.column "surname", :text, :null => false
      t.column "forename", :text, :null => false
      t.column "sex", :text, :null => false
      t.column "start_time", :timestamp, :null => false
      t.column "end_time", :timestamp, :null => false
      t.column "cons_surg", :text, :null => false
      t.column "cons_anaes", :text, :null => false
      t.column "diagnosis", :text, :null => false
      t.column "operation", :text, :null => false
      t.column "cepod", :text, :null => false
      t.column "asa", :integer, :null => false
      t.column "anaesthetic", :text, :null => false
      t.column "surgeon1", :text, :null => false
      t.column "surgeon2", :text
      t.column "surgeon3", :text
      t.column "assistant1", :text
      t.column "assistant2", :text
      t.column "assistant3", :text
      t.column "anaesthetist1", :text
      t.column "anaesthetist2", :text
      t.column "anaesthetist3", :text
      t.column "dvt_lmwh", :boolean, :null => false
      t.column "dvt_ted", :boolean, :null => false
      t.column "dvt_pneum", :boolean, :null => false
      t.column "antibiotics", :text
      t.column "indication", :text, :null => false
      t.column "position", :text, :null => false
      t.column "incision", :text, :null => false
      t.column "findings", :text, :null => false
      t.column "proc_text", :text, :null => false
      t.column "cancer", :text, :null => false
      t.column "ebl", :text
      t.column "transfusion", :text
      t.column "post_op", :text, :null => false
    end

    create_table "op_templates", :force => true do |t|
      t.column "surgeon", :text, :null => false
      t.column "operation", :text, :null => false
      t.column "position", :text, :null => false
      t.column "incision", :text, :null => false
      t.column "proc_text", :text, :null => false
      t.column "post_op", :text, :null => false
    end

  end

  def self.down
    drop_table :op_list_entries
    drop_table :op_lists
    drop_table :op_notes
    drop_table :op_templates
  end
end
