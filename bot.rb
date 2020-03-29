require 'sinatra/base'

class CoronaChat < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  post '/bot' do
    body = params['Body'].downcase
    response = Twilio::TwiML::MessagingResponse.new

    response.message do |message|
      case body
      when 'hey'
        message.body("Hello, Welcome to the Official Chatbot of the Kerala Goverment.\n\nEnter one of the options given below,\n1. Information about COVID 19 in Kerala")
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
