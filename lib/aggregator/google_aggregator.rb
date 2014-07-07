class Aggregator::GoogleAggregator < Aggregator::GeneralAggregator

  # this is really bad but it needs to be finished within an hour

  def get_mongoose mongoose_logs, logs
    market = logs.first['market'] || 'none'
    keyword_lookup = Lookup::GoogleBingLookup.parsed_keyword_to_market
    tracking_number_lookup = Lookup::GoogleBingLookup.market_to_tracking_number
    _mongoose_logs = mongoose_logs.select do |m_log|
      next if m_log['keyword_source'] != 'Google'
      _market = nil

      if (keyword = m_log['keyword']) && (keyword.include?("|"))
        market_key = keyword.split('|')[2]
        keyword_lookup[market] = keyword.split('|')[2]
        _market = keyword_lookup[market_key]
      end

      if (!_market) && (tracking_number = m_log['tracking_number'])
        _market = tracking_number_lookup[m_log['tracking_number']]
      end
      market == _market
    end
    _mongoose_logs
  end

end