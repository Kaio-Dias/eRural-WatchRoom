module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :client_id

    def connect
      self.client_id = find_or_set_client_id
    end

    private

    def find_or_set_client_id
      cookies.signed[:client_id] ||= SecureRandom.uuid
    end
  end
end
