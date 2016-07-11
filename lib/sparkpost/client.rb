module SparkPost
  class Client
    attr_reader :transmission
    attr_reader :template
    def initialize(api_key = nil, api_host = 'https://api.sparkpost.com')
      @api_key = (api_key || ENV['SPARKPOST_API_KEY']).to_s
      @api_host = (api_host || ENV['SPARKPOST_API_HOST']).to_s

      raise ArgumentError, 'No API key is provided. Either provide
       api_key with constructor or set SPARKPOST_API_KEY environment
        variable' if @api_key.blank?

      raise ArgumentError, 'No API host is provided. Either provide
       api_host with constructor or set SPARKPOST_API_HOST environment
        variable' if @api_host.blank?
    end

    def transmission
      @transmission ||= Transmission.new(@api_key, @api_host)
    end

    def message_events
      @message_events ||= Message_events.new(@api_key, @api_host)
    end

    def suppression_list
      @suppression_list ||= Suppression_list.new(@api_key, @api_host)
    end

    def template
      @template ||= Template.new(@api_key, @api_host)
    end

    def metrics
      @metrics ||= Metrics.new(@api_key, @api_host)
    end
  end
end
