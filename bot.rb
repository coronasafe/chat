require 'sinatra/base'
require 'http'
require 'json'

class CoronaChat < Sinatra::Base
  use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  post '/bot' do
    body = params['Body'].downcase
    response = Twilio::TwiML::MessagingResponse.new

    response.message do |message|
      case body
      when 'hey', 'hi', 'hello'
        message.body(generate_hey_response)
      when '1'
        message.body(kerala_status_response)
      when 'status'
        message.body("Hey you entered info")
      else
        message.body("Sorry! The command you entered is not recognized, please try entering **menu** or **info**")
      end
    end

    content_type "text/xml"
    response.to_xml
  end

  def generate_hey_response
    "Hello, Welcome to the Official Chatbot of the Kerala Goverment." \
    "\n\nEnter one of the options given below" \
    "\n1. Current status of Kerala"
  end

  def kerala_status_response
    resp = HTTP.get("http://volunteer.coronasafe.network/api/reports")
    data_json = JSON.parse(resp.body.to_s)
    data = data_json["kerala"]

    number_of_confirmed = 0
    number_of_under_observation = 0

    data.each do |key, value| 
      number_of_confirmed += value["corona_positive"].to_i
      number_of_under_observation += value["under_observation"].to_i
    end

    return ("There has **not** been any signs of Community Spread in Kerala. The current status of Kerala is," \
            "\n\nConfirmed Cases : #{number_of_confirmed}" \
            "\nPeople Under Observation : #{number_of_under_observation}"
           )
  end
end
