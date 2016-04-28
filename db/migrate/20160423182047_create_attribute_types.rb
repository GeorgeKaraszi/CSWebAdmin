class CreateAttributeTypes < ActiveRecord::Migration
  def change
    create_table :attribute_types do |t|
      t.string :name, null: false, :unique => true
      t.string :ou_type, null: false

      t.timestamps null: false
    end
  end
end
