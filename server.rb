require 'goliath'
require 'omnipipe'
require 'goliath/rack/templates'

class PipeWelcome < Goliath::API
  include Goliath::Rack::Templates

  def response(env)
    [200, {}, erb(:index)]
  end
end

class PipeServer < Goliath::API
  use Rack::Static, :urls => ['/public']

  get '/', PipeWelcome
  get '/cmd', OmniPipe
end
