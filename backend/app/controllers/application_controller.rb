class ApplicationController < ActionController::Base
  # [AI Generated] Data: 21/10/2025
  # Descrição: Serve o frontend Vue.js para todas as rotas SPA.
  # Gerado por: Cursor AI
  # AI_GENERATED_CODE_START
  def index
    send_file Rails.root.join('public', 'index.html'), type: 'text/html', disposition: 'inline'
  end
  # AI_GENERATED_CODE_END
end
