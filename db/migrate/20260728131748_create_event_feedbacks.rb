class CreateEventFeedbacks < ActiveRecord::Migration[8.1]
  def change
    create_table :event_feedbacks do |t|
      t.references :event, null: false, foreign_key: true
      t.references :volunteer, null: false, foreign_key: true
      t.integer :rating
      t.text :comment
      # comment is opsiyonel

      t.timestamps
    end
  end
end
