class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :amazon_user_id
      t.timestamps
    end
    add_index :users, :amazon_user_id, unique: true
  end
end
