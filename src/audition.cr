require "./audition/*"
require "socket"
require "option_parser"

module Audition
  input = { "0.0.0.0", 7766 }
  output = { "0.0.0.0", 7767 }

  parser = OptionParser.new do |p|
    p.banner = "#{PROGRAM_NAME} [options]"

    p.on(
      "-i INPUT", "--input=INPUT",
      "Bind input to UDP socket to INPUT (default: #{input.join(':')})"
    ) do |string|
      host, port = string.split(':')
      input = { host, port.to_i }
    end

    p.on(
      "-o OUTPUT", "--output=OUTPUT",
      "Bind output to HTTP Server to OUTPUT (default: #{output.join(':')})"
    ) do |string|
      host, port = string.split(':')
      output = { host, port.to_i }
    end

    p.on("-h", "--help", "Show this and exit") do
      puts p.to_s
      exit
    end
  end

  parser.parse!

  Server.new(input, output).listen
end
