require 'net/http'

module Alexa

  class RequestVerifier

    TIMESTAMP_TOLERANCE = 150

    VALID_URI_HOSTNAME = 's3.amazonaws.com'
    VALID_URI_PATH_START = '/echo.api/'
    VALID_URI_SCHEME = 'https'
    VALID_URI_PORT = 443

    attr_reader :uri, :signature, :json_body, :request_body
    def initialize(request)
      @request_body = request.body.read
      @uri = URI.parse request.headers['SignatureCertChainUrl']
      @signature = request.headers['Signature']
      @json_body = JSON.parse request_body
    end

    def verify
      verify_timestamp
      verify_signature_cert_chain_url
      verify_encoded_certificate_chain
    end

    private

    def verify_timestamp
      if json_body['request']['timestamp'].nil?
        raise VerificationError.new
      end

      time_from_request = json_body['request']['timestamp']
      if time_from_request.is_a? String
        time = Time.parse time_from_request
      else
        time = Time.at time_from_request
      end

      if Time.now - TIMESTAMP_TOLERANCE >= time
        raise VerificationError.new
      end
    end

    def verify_signature_cert_chain_url
      if ![
        uri.scheme == VALID_URI_SCHEME,
        uri.port == VALID_URI_PORT,
        uri.host == VALID_URI_HOSTNAME,
        uri.request_uri.start_with?(VALID_URI_PATH_START)
      ].all?
        raise VerificationError.new
      end
    end

    def verify_encoded_certificate_chain
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      http.start
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      http.finish
      if response.code.to_i != 200
        raise VerificationError
      end
      certificate = OpenSSL::X509::Certificate.new response.body
      if !certificate.public_key.verify(OpenSSL::Digest::SHA1.new, Base64.decode64(signature), request_body)
        raise VerificationError.new
      end
    end

  end

end
