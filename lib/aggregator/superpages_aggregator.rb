class Aggregator::SuperpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    logs.map do |log|
      market_to_tracking = Lookup::SuperpagesLookup.market_to_tracking_number[log['market']]
      market_to_keyword = Lookup::SuperpagesLookup.market_to_keyword[log['market']]
      @mongoose_logs.select do |l| 
        l[tracking_number] == market_to_tracking || 
        l[tracking_number] == market_to_keyword
      end
    end.compact
  end

end