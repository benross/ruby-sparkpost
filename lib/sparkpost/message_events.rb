require 'net/http'
require 'uri'
require 'http'
require_relative '../core_extensions/object'
require_relative 'request'
require_relative 'exceptions'

module SparkPost
    class Message_events
        include Request

        def initialize(api_key, api_host)
            @api_key = api_key
            @api_host = api_host
            @base_endpoint = "#{@api_host}/api/v1/message-events" #Looks like -> https://api.sparkpost.com/api/v1/message-events?events=bounce,out_of_band
            @@valid_query_params = [
            "bounce_classes",
            "campaign_ids",
            "events",
            "friendly_froms",
            "from",
            "message_ids",
            "page",
            "per_page",
            "reason",
            "recipients",
            "subaccounts",
            "template_ids",
            "timezone",
            "to",
            "transmission_ids"
        ]
        end

        def make_query(opts)
            check_query_params(opts)
            send_query(opts)
        end

        def check_query_params(query_params)
            raise ArgumentError,
                "query params can't be blank" if query_params.empty?

            query_params.each do |key,val|
                raise ArgumentError,
                    "invalid query param: #{key}" if !@@valid_query_params.include? key.to_s
            end

            query_params
        end

        def send_query(data = {})
            request(endpoint(nil,data),@api_key,nil,"GET")
        end
    end
end


# bounce_classes - Comma-delimited list of bounce classification codes to search. (See Bounce Classification Codes.) Example: 1. - Number
# campaign_ids - Comma-delimited list of campaign ID's to search (i.e. campaign_id used during creation of a transmission). Example: Example Campaign Name. - String
# events - Comma-delimited list of event types to search. Defaults to all event types. Example: delivery, injection, bounce, delay, policy_rejection, out_of_band, open, click, generation_failure, generation_rejection, spam_complaint, list_unsubscribe, link_unsubscribe, relay_delivery, relay_injection, relay_permfail, relay_rejection, relay_tempfail. - List
# friendly_froms - Comma-delimited list of friendly_froms to search. Example: sender@mail.example.com. - List
# from - Datetime in format of YYYY-MM-DDTHH:MM. Example: 2014-07-20T08:00. Default: One hour ago. - Datetime
# message_ids - Comma-delimited list of message ID's to search. Example: 0e0d94b7-9085-4e3c-ab30-e3f2cd9c273e. - List
# page - The results page number to return. Used with per_page for paging through results. Example: 25. Default: 1. - Number
# per_page - Number of results to return per page. Must be between 1 and 10,000 (inclusive). Example: 100. Default: 1000. - Number
# reason - Bounce/failure/rejection reason that will be matched using a wildcard (e.g., %reason%). Example: bounce. - String
# recipients - Comma-delimited list of recipients to search. Example: recipient@example.com. - List
# subaccounts - Comma-delimited list of subaccount ID's to search. Example: 101. - List
# template_ids - Comma-delimited list of template ID's to search. Example: templ-1234. - List
# timezone - Standard timezone identification string. Example: America/New_York. Default: UTC. - String
# to - Datetime in format of YYYY-MM-DDTHH:MM. Example: 2014-07-20T09:00. Default: now. - Datetime
# transmission_ids - Comma-delimited list of transmission ID's to search (i.e. id generated during creation of a transmission). Example: 65832150921904138