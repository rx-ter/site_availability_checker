# main module of application
module PokuponDeamon
  require 'faraday'
  require 'yaml'
  require 'time'

  loop do
    begin
      domains = [Faraday.new(url: ENV['domain1']),
                 Faraday.new(url: ENV['domain2'])]
      domains_with_error = {}
      domains.each do |domain|
        response = domain.get '/'
        if response.status != 200 &&
           domains_with_error[domain.url_prefix.to_s] == false
          # puts "#{Time.now.httpdate} domain #{domain.url_prefix} error,
          #     with message #{response.reason_phrase}"
          domains_with_error[domain.url_prefix.to_s] = true
          send_mail_error(domain.url_prefix.to_s,
                          response.reason_phrase,
                          response.status)
        elsif domains_with_error[domain.url_prefix.to_s] == true
          domains_with_error[domain.url_prefix.to_s] = false
          send_mail_success(domain.url_prefix.to_s,
                            response.reason_phrase,
                            response.status)
          # puts "#{Time.now.httpdate} domain #{domain.url_prefix} all is good"
        end
      end
      sleep(60) # delay for domains check
    rescue Interrupt
      puts 'Exiting...'
      break
    end
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
