class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table "<%= table_name %>", :force => true do |t|
      t.string :name
      t.string :category
      t.integer :parent_id

      t.timestamps
    end
  end

  def self.down
    drop_table "<%= table_name %>"
  end
end
