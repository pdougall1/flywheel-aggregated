class Aggregator::CitygridAggregator < Aggregator::GeneralAggregator

  def destination_number
    '9793144195'
  end

  def get_mongoose
    market = logs.first['market'] || 'none'
    keywords = Lookup::CitygridLookup.market_to_keyword[market]
    tracking_numbers = Lookup::CitygridLookup.market_to_tracking_number[market]
    all_mongoose_logs.select do |m_log|
      keyword = keywords.include? m_log['keyword']
      tracking_number = tracking_numbers.include? m_log['tracking_number']
      keyword || tracking_number
    end
  end

end
