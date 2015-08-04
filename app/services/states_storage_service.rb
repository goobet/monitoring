class StatesStorageService

  class << self
    def all_machines
      $redis.smembers('machines')
    end

    def save(machine_state)
      hostname = machine_state[:hostname]
      $redis.sadd("machines", hostname)
      
      json = {
        cpu: machine_state[:load_average],
        mem: machine_state[:free_memory]
      }.to_json

      dates = $redis.hkeys(hostname)

      $redis.hdel(hostname, dates.first) if dates.size > 120

      time_now = Time.now.to_i
      time_now = time_now - time_now % 5
      $redis.hset(hostname, time_now, json)
      
      $redis.set("online:#{hostname}", json)
      $redis.expire("online:#{hostname}", 5)
    end

    def current_states(machines)
      prefix = 'online:'
      $redis.mapped_mget(*(machines.map {|m| "#{prefix}#{m}"})).map do |host, json|
        status = json.present?
        state = {hostname: host[prefix.length..-1], status: status ? 'UP' : 'DOWN'}

        state.merge(status ? JSON.parse(json) : {'cpu': 0, 'mem': 0} )
      end
    end

    def last_states(machines)
      data = machines.map {|m| [m, $redis.hgetall(m)]}.to_h
      transform(data)
    end

    private

    def transform(data)
      transformed = {}

      params = ['cpu', 'mem']

      time_now = Time.now.to_i    
      from_time =  time_now - time_now % 5 - 600

      data.each do |host, data|
        host_data = {}

        (0...120).each do |t|
          date = from_time + t*5
          value = data[date.to_s]
          parsed_value = value.present? ? JSON.parse(value) : {}
          params.each do |param| 
            host_data[param] ||= []
            host_data[param] << [date, (parsed_value[param] || 0)]

          end
        end

        host_data.each do |param, data|
          transformed[param] ||= []
          transformed[param] << {
            name: host,
            type: 'area',
            data: data
          }
        end
      end

      transformed
    end
  end

end