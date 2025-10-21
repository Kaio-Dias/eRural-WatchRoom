class RoomsController < ApplicationController
  def show
    slug_or_id = params[:slug] || params[:id]
    room = Room.find_by(slug: slug_or_id)

    unless room
      room = Room.create!(slug: slug_or_id, creator_nickname: 'Guest')
    end

    respond_to do |format|
      format.json { render json: room }
      format.html { send_file Rails.root.join('public', 'index.html'), type: 'text/html', disposition: 'inline' }
    end
  end

  def create
    room = Room.new(room_params)
    if room.save
      render json: room, status: :created
    else
      render json: { errors: room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:creator_nickname, :slug)
  end
end