require File.dirname(__FILE__) + '/pokupon_service.rb'

checker = PokuponService::SiteChecker.new
loop do
  begin
    checker.check_domains
    sleep(60) # delay for domains check
  rescue Interrupt
    puts 'Exiting...'
    break
  end
end
