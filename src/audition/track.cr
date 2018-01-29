require "json"

module Audition
  struct Track
    JSON.mapping(
      artists: Array(String),
      title: String,
      album: String?
    )

    def to_s(io)
      io << "#{artists.join(", ")} - #{title}"
      io << " [#{album}]" if album
    end
  end
end
