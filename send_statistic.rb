require 'usagewatch'
require 'httparty'

usw = Usagewatch

host = ENV['MONITORING_OCTOPUS']
hostname = ENV['MACHINE_NAME']

while true do
    begin
        HTTParty.post("http://#{host}/machines_statistic", 
            body: {'hostname': hostname, 'memory_usage': usw.uw_memused, 'cpu_usage': usw.uw_cpuused, 'status': 'Up' })
        puts "Statistic was sent."
    rescue 
        puts "Server is not available."
    end
    sleep 3
end
