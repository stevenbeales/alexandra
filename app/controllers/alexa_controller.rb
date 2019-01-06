class AlexaController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_alexa_authenticity

  rescue_from Alexa::VerificationError, with: :render_malformed_request_response

  def main
    requestHandler = Alexa::RequestHandler.new params.permit!
    render json: requestHandler.process
  end

  private

  def verify_alexa_authenticity
    Alexa::RequestVerifier.new(request).verify
  end

  def render_malformed_request_response
    head 400
  end

end
