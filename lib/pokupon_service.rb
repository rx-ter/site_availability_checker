# main module of application
module PokuponService
    # class for check sites and process it
    class SiteChecker
      require 'faraday'
      require 'yaml'
      require 'time'
  
      def initialize
        config = YAML.safe_load(
          File.read(
            File.expand_path('../../config/application.yml', __FILE__)
          )
        )
        config.each do |key, value|
          ENV[key] = value unless value.is_a? Hash
        end
        @domains_with_error = {}
      end
  
      def check_domains
        domains = get_sites
        domains.each do |domain|
          response = domain.get '/'
          if response.status != 200 &&
             @domains_with_error[domain.url_prefix.to_s] == false
            process_error(domain, response)
          elsif @domains_with_error[domain.url_prefix.to_s] == true
            process_success(domain, response)
          else
            puts "#{Time.now.httpdate} domain #{domain.url_prefix} all is good"
          end
        end
      end
  
      def get_sites
        [Faraday.new(url: ENV['domain1']),
        Faraday.new(url: ENV['domain2'])]
      end
  
      def process_error(domain, response)
        puts "#{Time.now.httpdate} domain #{domain.url_prefix} error,
        with message #{response.reason_phrase}"
        @domains_with_error[domain.url_prefix.to_s] = true
        send_mail_error(domain.url_prefix.to_s,
                        response.reason_phrase,
                        response.status)
      end
  
      def process_success(domain, response)
        @domains_with_error[domain.url_prefix.to_s] = false
        send_mail_success(domain.url_prefix.to_s,
                          response.reason_phrase,
                          response.status)
        puts "#{Time.now.httpdate} domain #{domain.url_prefix} all is good"
      end
  
      def send_mail_error(domain, response_message, status)
        Mail.deliver do
          from 'ruby.pokupon.deamon@test.net'
          to ENV['mail']
          subject  "There is some error with #{domain}"
          body     "Time of error is #{Time.now.httpdate}
          Error status is #{status}\n
          Error message is #{response_message}"
        end
      end
  
      def send_mail_success(domain, response_message, status)
        Mail.deliver do
          from 'ruby.pokupon.deamon@test.net'
          to ENV['mail']
          subject  "Error with #{domain} has been resolved"
          body     "Time of error is #{Time.now.httpdate}\n
          Error status now is #{status}\n
          response message is #{response_message}"
        end
      end
    end
  end
  