module YouTube
  class ParserService
    def self.extract_id(url_or_id)
      return url_or_id if url_or_id.to_s.match?(/\A[a-zA-Z0-9_-]{11}\z/)

      uri = URI.parse(url_or_id.to_s)
      
      case uri.host
      when 'youtu.be'
        uri.path[1..-1]
      when /youtube\.com$/
        params = URI.decode_www_form(uri.query || '').to_h
        params['v']
      else
        nil
      end
    rescue URI::InvalidURIError
      nil
    end
  end
end