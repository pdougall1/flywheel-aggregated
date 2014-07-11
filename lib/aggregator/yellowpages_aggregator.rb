class Aggregator::YellowpagesAggregator < Aggregator::GeneralAggregator

  # this vendor does not require mongoose logs

  def destination_number
    '3177595208'
  end

  def braxtel_logs
    if @braxtel_logs
      return @braxtel_logs
    else
      @braxtel_logs = all_braxtel_logs.select { |l| l['destination_number'] == destination_number }
      ids = @logs.map { |log| log['pivot_field'] } # pivot_field is the Customer value from the raw data without dashes
      @braxtel_logs.keep_if do |b_log|
        id = ids.include? b_log['customer_id']
        market = b_log['market'] == @market
        id || market
      end
    end
  end

  def get_calls
    logs.reduce(0) do |acc, log|
      seconds = get_seconds log['call_duration']
      acc += 1 if seconds >= 60
      acc
    end
  end

  def get_seconds call_duration
    time_arr = call_duration.split(':')
    (time_arr[0].to_i * 60) + time_arr[1].to_i
  end

end