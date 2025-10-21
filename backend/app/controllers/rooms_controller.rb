class RoomsController < ApplicationController
  def show
    # [AI Generated] Data: 21/10/2025
    # Descrição: Serve HTML para SPA ou JSON para API conforme Accept header.
    # Gerado por: Cursor AI
    # AI_GENERATED_CODE_START
    slug_or_id = params[:slug] || params[:id]
    room = Room.find_by(slug: slug_or_id)
    
    # Se não encontrar, cria uma nova sala com o slug/id fornecido
    unless room
      room = Room.create!(slug: slug_or_id, creator_nickname: 'Anon')
    end
    
    respond_to do |format|
      format.json { render json: room }
      format.html { send_file Rails.root.join('public', 'index.html'), type: 'text/html', disposition: 'inline' }
    end
    # AI_GENERATED_CODE_END
  end

  def create
    room = Room.new(room_params)
    if room.save
      render json: room, status: :created
    else
      render json: room.errors, status: :unprocessable_entity
    end
  end

  private

  def room_params
    params.require(:room).permit(:creator_nickname)
  end
end
