class RemoveParentPostFromComments < ActiveRecord::Migration[7.0]
  def change
    remove_reference :comments, :parent_post, polymorphic: true, null: false, index: true
  end
end
