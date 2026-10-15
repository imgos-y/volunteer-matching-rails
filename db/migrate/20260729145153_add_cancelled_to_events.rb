class AddCancelledToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :cancelled, :boolean, default: false
  end
end
