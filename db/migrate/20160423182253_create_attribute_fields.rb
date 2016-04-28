class CreateAttributeFields < ActiveRecord::Migration
  def change
    create_table :attribute_fields do |t|
      t.string :field_type, null: false
      t.boolean :required, default: false
      t.belongs_to :attribute_type, index: true, foreign_key: true
      t.belongs_to :attribute_name, index: true

      t.timestamps null: false
    end
  end
end
