# [AI Generated] Data: 21/10/2025
# Descrição: Sanitiza texto de chat e nomes de usuário.
# Gerado por: Cursor AI
# AI_GENERATED_CODE_START
module SanitizationService
  extend self

  # Remove tags HTML, normaliza, comprime espaços, remove caracteres de controle, limita tamanho
  def sanitize_chat_text(text, max_len: 500)
    str = text.to_s
    # remove tags e atributos
    stripped = ActionController::Base.helpers.sanitize(str, tags: [], attributes: [])
    # remove caracteres de controle/zws
    cleaned = stripped.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
                     .gsub(/[\u0000-\u001F\u007F\u200B\u200C\u200D]/, '')
    # normaliza espaços
    normalized = cleaned.gsub(/\s+/, ' ').strip
    normalized[0, max_len]
  end

  # Normaliza e limita nome de usuário
  def sanitize_user_name(name, max_len: 64)
    str = name.to_s
    cleaned = str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')
                     .gsub(/[\u0000-\u001F\u007F\u200B\u200C\u200D]/, '')
    normalized = cleaned.gsub(/\s+/, ' ').strip
    (normalized.presence || 'Anon')[0, max_len]
  end
end
# AI_GENERATED_CODE_END