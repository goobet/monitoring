class MonitoringController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
  	@machines_all = $redis.smembers("machines")
  	@machines_parameters = set_machine_parameters
  end

  def machines_statistic
  	$redis.sadd("machines", params[:hostname])
  	set_machine_parameters.each do |parameter|
  	 $redis.hset(parameter, params[:hostname], params[parameter.to_sym])
 	 $redis.expire("status", 10)
 	end 
    render nothing: true
  end

  def set_machine_parameters
  	machines_parameters = ["cores", "available_memory", "load_average", "memory_usage", "status"]
  end

end
