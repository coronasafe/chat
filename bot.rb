require 'sinatra/base'

class CoronaChat < Sinatra::Base
  get '/' do
    'Hello Corona'
  end
end
