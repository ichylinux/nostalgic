class ChangeColumnCreatedAtOnNostalgicAttrs < ActiveRecord::Migration
  def up
    change_column :nostalgic_attrs, :created_at, :datetime, :null => true
  end
  def down
    change_column :nostalgic_attrs, :created_at, :datetime, :null => false
  end
end
