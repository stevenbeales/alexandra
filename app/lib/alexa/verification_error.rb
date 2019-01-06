module Alexa

  class VerificationError < StandardError

    def initialize(msg="Invalid Alexa Request")
      super msg
    end

  end

end
