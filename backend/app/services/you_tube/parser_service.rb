module YouTube
  class ParserService
    # [AI Generated] Data: 21/10/2025
    # Descrição: Extrai o ID de vídeo do YouTube de URLs ou IDs brutos.
    # Gerado por: Cursor AI
    # AI_GENERATED_CODE_START
    def self.extract_id(url_or_id)
      return url_or_id if url_or_id.to_s.match?(/\A[a-zA-Z0-9_-]{11}\z/) # Already an ID

      uri = URI.parse(url_or_id)
      params = URI.decode_www_form(uri.query || '').to_h
      return params['v'] if params['v'].present?

      # Handle short URLs like youtu.be/VIDEO_ID
      if uri.host == 'youtu.be'
        return uri.path.delete('/')
      end

      # Handle embed URLs
      if uri.path.include?('/embed/')
        return uri.path.split('/embed/').last.split('?').first
      end

      nil
    rescue URI::InvalidURIError
      nil
    end
    # AI_GENERATED_CODE_END
  end
end