module AlexaRubykit

  # Returns true if all the Alexa request objects are set.
  def self.valid_alexa?(request_json)
    !request_json.nil? &&
      !request_json['session'].nil? &&
      !request_json['request'].nil?
  end

end
