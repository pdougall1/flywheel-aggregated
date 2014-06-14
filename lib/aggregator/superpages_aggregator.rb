class Aggregator::SuperpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    logs.map do |log|
      market = log.market
      ml = MongooseLog.find_by_tracking_number Lookup::SuperpagesLookup.market_to_tracking_number[market]
      ml = MongooseLog.find_by_tracking_number Lookup::SuperpagesLookup.market_to_keyword[market] unless ml
      ml
    end.compact
  end

end