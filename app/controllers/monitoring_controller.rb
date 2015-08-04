class MonitoringController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_machines, only: [:index, :stats]

  def index
    @machines_states = StatesStorageService.current_states(@machines)
    @stats = StatesStorageService.last_states(@machines)
  end

  def stats
    render json: StatesStorageService.current_states(@machines)
  end

  def machines_statistic
    StatesStorageService.save machine_params
    render nothing: true
  end

  private

  def set_machines
    @machines = StatesStorageService.all_machines
  end

  def machine_params
    params.permit(:hostname, :load_average, :free_memory)
  end
end