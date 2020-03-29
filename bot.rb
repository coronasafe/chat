require 'sinatra/base'

class CoronaChat < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  post '/bot' do
    body = params['Body'].downcase
    response = Twilio::TwiML::MessagingResponse.new

    response.message do |message|
      case body
      when 'info'
        message.body("Hey you entered info")
      else
        message.body("Sorry! The command you entered is not recognized, please try entering **menu** or **info**")
      end
    end

    content_type "text/xml"
    response.to_xml
  end
end
