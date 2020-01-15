require 'uri'
require 'net/http'
require 'openssl'
require_relative '../utils/output'

class GithubAction
  CONFIG_PATH = '/usr/local/etc/alfred_pr_review_config.json'
  class << self
    # pull request review url
    # => https://github.com/Overseas-Student-Living/properties-service/pull/1

    # API url
    # https://api.github.com/repos/Overseas-Student-Living/properties-service/pulls/1
    def get_api_url(input_value)
      return "https://api.github.com/repos/#{input_value.split('github.com/')[1].gsub('pull', 'pulls')}"
    end

    def polish_url(input_value)
      pr_number = input_value.gsub(/[^0-9]/, '')
      return "#{input_value.split(pr_number)[0]}#{pr_number}"
    end

    def get_config_data
      if File.exist? CONFIG_PATH
        begin
          config = JSON.parse(File.read(CONFIG_PATH))
          return config
        rescue => exception
          return {}
        end
      end
      return {}
    end


    def get_pr(input_value)
      pr_url = polish_url(input_value)
      config_data = get_config_data

      url = URI(get_api_url(pr_url))
        
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      
      request = Net::HTTP::Get.new(url)
      request["cookie"] = 'logged_in=no'
      request["authorization"] = "token #{config_data["github_token"]}"
      
      response = http.request(request)
      hash_response = JSON.parse(response.read_body)
      title = hash_response["title"]
review_string = <<~REW_STR
*Please review*
&|&|&|
#{title}
&|&|&|
#{pr_url}
@here **** #{config_data["slack_channel"]}
REW_STR
    
      puts review_string
    end
	end
end

