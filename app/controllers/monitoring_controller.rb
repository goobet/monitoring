class MonitoringController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
  	@machines_all = $redis.smembers("machines")
  end

  def machines_statistic
  	
  	$redis.sadd("machines", "#{params[:hostname]}")
  	
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
