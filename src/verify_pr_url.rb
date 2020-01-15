require 'uri'
require 'net/http'
require 'openssl'
require_relative '../utils/output'

class VerifyPrUrl
  class << self
    def url_valid?(url)
      url = URI.parse(url) rescue false
      url.kind_of?(URI::HTTP) || url.kind_of?(URI::HTTPS)
    end

    def is_valid_pr_url(input_value)
      url = input_value.to_s
      return url_valid?(url) && url.include?('github') && url.include?('pull')
    end

    def verify(input_value)
      if !input_value
        item = {
          :title => 'Waiting for input',
          :subtitle =>  'Waiting for input',
        }
      elsif is_valid_pr_url(input_value)
        item = {
          :title => "Valid PR URL! Press ENTER to do autocomplete in slack!",
          :arg => input_value
        }
      else
        item = {
          :title => 'Invalid PR URL.',
        }
      end
      Output.put(item)
    end
	end
end

