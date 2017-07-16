class AddListAuthor < ActiveRecord::Migration
  def self.up
    add_column :op_lists, :list_author_id, :integer
    add_column :op_lists, :list_author_type, :text
  end

  def self.down
    remove_column :op_lists, :list_author_id
    remove_column :op_lists, :list_author_type
  end
end
