class RemoveColumnFromPost < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :description_ar
    remove_column :posts, :description_en

  end
end
