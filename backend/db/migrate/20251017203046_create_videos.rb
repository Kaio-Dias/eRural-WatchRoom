class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :title

      t.timestamps
    end
  end
end
