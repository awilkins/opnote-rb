class CreateAnaesthetists < ActiveRecord::Migration
  def self.up
    create_table :anaesthetists do |t|
      t.column :surname, :text, :null => false
      t.column :initials, :text, :null => false
      t.column :consultant, :boolean, :null => false
    end
  end

  def self.down
    drop_table :anaesthetists
  end
end
