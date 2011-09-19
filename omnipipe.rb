require 'goliath'
require 'em-synchrony/em-http'
require 'em-http/middleware/json_response'

class OmniPipe < Goliath::API

  VERSION = "0.0.1"
  HEADERS = {"X-Pipe" => VERSION}

  use Goliath::Rack::Params
  use Goliath::Rack::Validation::RequestMethod, %w(GET)          # GET requests only
  use Goliath::Rack::Validation::RequiredParam, {:key => 'cmd'}  # must provide ?cmd= param

  use Goliath::Rack::Render, ['json', 'html']

  def response(env)
    input, cmd = params['cmd'].split('|').map &:strip
    return [400, HEADERS, "Chaining is not supported.. yet!"] if cmd.is_a? Array

    cmd, args = cmd.split(' ')
    logger.info "Processing, input: #{input}, cmd: #{cmd}, args: #{args}"

    case cmd
    when 'googl'
      # http://code.google.com/apis/urlshortener/v1/getting_started.html#shorten
      conn = EM::HttpRequest.new('https://www.googleapis.com/urlshortener/v1/url')
      conn.use EM::Middleware::JSONResponse

      resp = conn.post(:body => Yajl::Encoder.encode({"longUrl" => input}),
                       :head => { 'Content-Type' => 'application/json' })

      logger.debug "Shortened URI via goo.gl: #{resp.response['id']}"
      [302, HEADERS.merge({'Location' => resp.response['id'] + "+" }), nil]

    when 'grep'
      regex = Regexp.new(Regexp.escape(args))
      match = []

      page = EM::HttpRequest.new(input).get
      page.response.split(/\r\n|\n/).each_with_index do |l,i|
        match.push "#{i}: #{l.strip}" if l =~ regex
      end

      [200, HEADERS, match.join("\n")]

    else
      [400, HEADERS, "Uknown command '#{cmd}'"]
    end

  end
end
