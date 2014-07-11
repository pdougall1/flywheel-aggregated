class Aggregator::MarchexAggregator < Aggregator::GeneralAggregator

  def destination_number
    '3177595209'
  end

  def get_mongoose
    b_logs = all_braxtel_logs.keep_if { |l| l['destination_number'] == destination_number } if destination_number
    caller_ids = b_logs.map { |l| l['caller_id'] }
    all_mongoose_logs.select do |m_log|
      caller_ids.include? m_log['caller_id'] 
    end
  end

end