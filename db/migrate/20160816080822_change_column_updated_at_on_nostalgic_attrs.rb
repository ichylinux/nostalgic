class ChangeColumnUpdatedAtOnNostalgicAttrs < ActiveRecord::Migration
  def up
    change_column :nostalgic_attrs, :updated_at, :datetime, :null => true
  end
  def down
    change_column :nostalgic_attrs, :updated_at, :datetime, :null => false
  end
end
