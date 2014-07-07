class Aggregator::CitygridAggregator < Aggregator::GeneralAggregator

  def get_mongoose mongoose_logs, logs
    market = logs.first['market'] || 'none'
    keywords = Lookup::CitygridLookup.market_to_keyword[market]
    tracking_numbers = Lookup::CitygridLookup.market_to_tracking_number[market]
    mongoose_logs.select do |m_log|
      keyword = keywords.include? m_log['keyword']
      tracking_number = tracking_numbers.include? m_log['tracking_number']
      keyword || tracking_number
    end
  end

end
