class CreateParticipants < ActiveRecord::Migration[8.0]
  def change
    create_table :participants do |t|
      t.string :nickname
      t.boolean :is_host
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
