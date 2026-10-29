class AddCancellationReasonToEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :events, :cancellation_reason, :string
  end
end
