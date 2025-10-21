class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :slug
      t.string :creator_nickname
      t.string :current_video_id

      t.timestamps
    end
    add_index :rooms, :slug, unique: true
  end
end
