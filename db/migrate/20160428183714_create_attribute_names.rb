class CreateAttributeNames < ActiveRecord::Migration
  def change
    create_table :attribute_names do |t|
      t.string :keyattribute, null: false, :unique => true
      t.string :description, default: :keyattribute

      t.timestamps null: false
    end
  end
end
