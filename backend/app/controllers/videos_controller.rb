class VideosController < ApplicationController
  before_action :set_room

  def create
    @video = @room.videos.new(video_params)
    if @video.save
      render json: @video, status: :created
    else
      render json: @video.errors, status: :unprocessable_entity
    end
  end

  def update
    @video = @room.videos.find(params[:id])
    @room.update(current_video_id: @video.youtube_id)
    head :no_content
  end

  private

  def set_room
    @room = Room.find_by(slug: params[:room_slug])
  end

  def video_params
    params.require(:video).permit(:youtube_id, :title)
  end
end
