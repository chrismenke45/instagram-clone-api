class RemoveHashPasswordFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :hash_password, :string
  end
end
