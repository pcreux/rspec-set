class CreateActiveRecordClassExample < ActiveRecord::Migration
  def change
    create_table :active_record_class_examples do |t|
      t.string  :name
      t.integer :age
    end
  end
end