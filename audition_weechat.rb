# frozen_string_literal: true
require 'net/http'

SCRIPT_NAME = 'audition'
AUTHOR = 'Joakim Reinert'
VERSION = '0.1.0'
LICENSE = 'MIT'
DESCRIPTION = 'Simple now playing script using audition'
DEFAULT_OPTIONS = {
  host: 'http://localhost:7767',
  format: '/me is listening to %<track>s'
}.freeze

@options = DEFAULT_OPTIONS.dup

def set_options(*)
  DEFAULT_OPTIONS.each do |key, value|
    if Weechat.config_is_set_plugin(key.to_s) == 1
      @options[key] = Weechat.config_get_plugin(key.to_s)
    else
      Weechat.config_set_plugin(key.to_s, value)
    end
  end

  Weechat::WEECHAT_RC_OK
end

def np_callback(*)
  uri = URI(@options[:host])
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    response = http.get('/')
    track = response.body
    buffer = Weechat.current_buffer
    Weechat.command(buffer, format(@options[:format], track: track))
  end

  Weechat::WEECHAT_RC_OK
end

def setup_command
  Weechat.hook_command(
    'np', 'Post now playing song to current buffer', '[]',
    '', '', 'np_callback', ''
  )
end

def weechat_init
  Weechat.register(
    SCRIPT_NAME,
    AUTHOR,
    VERSION,
    LICENSE,
    DESCRIPTION,
    '', ''
  )

  set_options
  setup_command
  Weechat.hook_config("plugins.var.ruby.#{SCRIPT_NAME}.*", 'set_options', '')

  Weechat::WEECHAT_RC_OK
end
