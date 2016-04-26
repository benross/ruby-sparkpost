require 'net/http'
require 'uri'
require 'http'
require_relative '../core_extensions/object'
require_relative 'request'
require_relative 'exceptions'

module SparkPost
    class Suppression_list
        include Request
        def initialize(api_key, api_host)
            @api_key = api_key
            @api_host = api_host
            @base_endpoint = "#{@api_host}/api/v1/suppression-list" 
            @@valid_query_params = [
            "from",
            "to",
            "types",
            "sources",
            "limit"
            ]
        end

        #Body Params need to look like this:
        # {
        # "recipients": [
        #   {
        #     "email": "rcpt_1@example.com",
        #     "transactional": true,
        #     "description": "User requested to not receive any transactional emails."
        #   },
        #   {
        #     "email": "rcpt_2@example.com",
        #     "non_transactional": true
        #   }
        #     ]
        # }
        # SEE: https://developers.sparkpost.com/api/#/reference/message-events/events-documentation/search-for-list-entries
        # {recipients:[email:"captest@testacular.com",transactional:true,description:"Just testing some stuff"]}

        def insert_address(data,opts = nil) #C
            request(endpoint,@api_key,data,"PUT")
        end

        #Looks like this:https://api.sparkpost.com/api/v1/suppression-list/rcpt_1@example.com

        def get_address_state(address,opts = nil) #R
            request(endpoint(address,opts),@api_key,nil,"GET")
        end

        def edit_address_state(data,opts=nil) #U
            request(endpoint,@api_key,data,"PUT")
        end

        # Looks like this: https://api.sparkpost.com/api/v1/suppression-list/rcpt_1@example.com

        def remove_address_from_list(address,opts = nil) #D
            request(endpoint(address,opts),@api_key,nil,"DELETE")
        end

        # Looks like this: https://api.sparkpost.com/api/v1/suppression-list?to=2014-07-20T09:00:00%2B0000&from=2014-07-20T09:00:00%2B0000&types=&limit=5

        # to - Datetime the entries were last updated, in the format of YYYY-MM-DDTHH:mm:ssZ Example: 2014-07-20T09:00:00%2B0000. Default: now.  Datetime
        # from - Datetime the entries were last updated, in the format YYYY-MM-DDTHH:mm:ssZ Example: 2014-07-20T09:00:00%2B0000.  Datetime
        # types - Types of entries to include in the search, i.e. entries with "transactional" and/or "non_transactional" keys set to true  List
        # sources - Sources of the entries to include in the search, i.e. entries that were added by this source  List
        # limit - Maximum number of results to return. Must be between 1 and 100000. Default value is 100000. Example: 5.  Int

        def search_address_list(opts)
            check_query_params(opts)
            request(endpoint(nil,opts),@api_key,nil,"GET")
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
    end
end

