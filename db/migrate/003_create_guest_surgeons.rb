class CreateGuestSurgeons < ActiveRecord::Migration
  def self.up
    create_table :guest_surgeons do |t|
      t.column :name, :text, :null => false
    end
  end

  def self.down
    drop_table :guest_surgeons
  end
end
