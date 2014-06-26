class Aggregator::YellowpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    logs.map do |log| 
      @mongoose_logs.select { |l| l['caller_id'] == log['customer'] }
    end
  end

end