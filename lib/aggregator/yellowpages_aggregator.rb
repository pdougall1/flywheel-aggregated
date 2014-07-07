class Aggregator::YellowpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose mongoose_logs, logs
    market = logs.first['market']
    trs = Lookup::YellowpagesLookup.market_to_tracking_number[market]
    logs = mongoose_logs.select do |l| 
      trs.include? l['tracking_number'] 
    end
    # debugger if logs.count > 0
    logs
  end

end