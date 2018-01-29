require "socket"
require "http/server"
require "./track"

module Audition
  class Server
    @now_playing : Track?
    @input : UDPSocket
    @output : HTTP::Server

    def initialize(input, output)
      @mutex = Channel(Bool).new(1)
      @mutex.send(true)

      @input = UDPSocket.new
      @input.bind(*input)
      @output = HTTP::Server.new(*output) do |context|
        handle_output_request(context)
      end
    end

    def listen
      spawn input_listener
      spawn output_listener
      sleep
    end

    private def output_listener
      puts "Listening for output requests on http://0.0.0.0:7767"
      @output.listen
    end

    private def input_listener
      puts "Listening for input requests on udp://0.0.0.0:7766"
      loop do
        line = @input.gets
        next unless line
        track = Track.from_json(line)
        puts "Updating now playing: #{track}"
        synchronize { @now_playing = Track.from_json(line) }
      end
    end

    private def handle_output_request(context)
      now_playing = synchronize { @now_playing }
      case context.request.headers["Accept"]?
      when "application/json" then now_playing.to_json(context.response)
      else now_playing.to_s(context.response)
      end
    end

    private def synchronize
      @mutex.receive
      yield
    ensure
      @mutex.send(true)
    end
  end
end
