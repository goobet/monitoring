class MonitoringController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
  	@octomachines_all = $redis.hgetall("octomachines").to_hash
  end

  def machines_statistic
  	machine_hostname = params[:hostname]
  	machine_status = params[:status]
  	machine_cores = params[:cores]
  	machine_available_memory = params[:available_memory]
  	machine_load_average = params[:load_average]
 	machine_memory_usage = params[:memory_usage]

    $redis.hset("octomachines", "#{params[:hostname]}", "#{params[:hostname]}") 	

  	$redis.hset("status", "#{params[:hostname]}", "#{params[:status]}")
 	$redis.expire("status", 10)
  
  	$redis.hset("cores", "#{params[:hostname]}", "#{params[:cores]}")
  	$redis.expire("cores", 10)

	$redis.hset("available_memory", "#{params[:hostname]}", "#{params[:available_memory]}")
  	$redis.expire("available_memory", 10)

  	$redis.hset("load_average", "#{params[:hostname]}", "#{params[:load_average]}")
  	$redis.expire("load_average", 10)

	$redis.hset("memory_usage", "#{params[:hostname]}", "#{params[:memory_usage]}")
  	$redis.expire("memory_usage", 10)
  
    render nothing: true
  end

end
