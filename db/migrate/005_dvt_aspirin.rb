class DvtAspirin < ActiveRecord::Migration
  def self.up
    add_column :op_notes, :dvt_aspirin, :boolean
  end

  def self.down
    remove_column :op_notes, :dvt_aspirin
  end
end
