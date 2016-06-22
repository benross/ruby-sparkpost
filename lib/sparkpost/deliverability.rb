require 'net/http'
require 'uri'
require 'http'
require_relative '../core_extensions/object'
require_relative 'request'
require_relative 'exceptions'

module SparkPost
    class Deliverability
        include Request
        @@valid_query_params = [
            "from",
            "to",
            "delimiter",
            "domains",
            "campaigns",
            "templates",
            "nodes",
            "sending_ips",
            "ip_pools",
            "sending_domains",
            "subaccounts",
            "protocols",
            "timezone",
            "metrics",
            "limit"
        ]

        def initialize(api_key, api_host)
            @api_key = api_key
            @api_host = api_host
            @base_endpoint = "#{@api_host}/api/v1/metrics/deliverability" #Looks like -> https://api.sparkpost.com/api/v1/metrics/deliverability/
        end

        def make_query(opts)
            raise ArgumentError,
                "Missing deliverability vector (i.e campaign/bounce-classification) See:https://developers.sparkpost.com/api/#/reference/metrics/" if opts[:vector].nil?
            @vector = opts[:vector]
            check_query_params(opts[:params])
            send_query(opts[:params])
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
            request(endpoint(@vector,data),@api_key,nil,"GET")
        end
    end
end



# from Datetime in format of YYYY-MM-DDTHH:MM Example: 2014-07-11T08:00. Datetime
# to Datetime in format of YYYY-MM-DDTHH:MM Example: 2014-07-20T09:00. Default: now. Datetime
# delimiter Specifies the delimiter for query parameter lists Example: :. Default: ,. String
# domains delimited list of domains to include Example: gmail.com,yahoo.com,hotmail.com. List
# campaigns delimited list of campaigns to include Example: Black Friday. List
# templates delimited list of template IDs to include Example: summer-sale. List
# nodes delimited list of nodes to include ( Note: SparkPost Elite only ) Example: Email-MSys-1,Email-MSys-2,Email-MSys-3,Email-MSys-4,Email-MSys-5. List
# sending_ips delimited list of sending IPs to include Example: Confirmation. List
# ip_pools delimited list of IP pools to include Example: Transaction. List
# sending_domains delimited list of sending domains to include Example: sales.sender.com,company.net. List
# subaccounts delimited list of subaccount ids to include (**Note:** providing ?subaccounts=0 will filter out all subaccount data, and only return master account data) Example: 123,125,127. List
# protocols delimited list of protocols for filtering ( Note: SparkPost Elite only ) Example: smtp. List
# timezone Standard timezone identification string, defaults to UTC Example: America/New_York. Default: UTC. String
# metrics delimited list of metrics to include List
# limit Maximum number of results to return Example: 5. Int  