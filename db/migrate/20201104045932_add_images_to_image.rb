class AddImagesToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :images, :json
  end
end
