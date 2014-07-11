class Aggregator::SuperpagesAggregator < Aggregator::GeneralAggregator

  def destination_number
    '3177595210'
  end

  def get_mongoose
    market = logs.first['market'] || 'none'
    keyword_lookup = Lookup::SuperpagesLookup.market_to_keyword
    tracking_number_lookup = Lookup::SuperpagesLookup.market_to_tracking_number
    _mongoose_logs = all_mongoose_logs.select do |m_log|
      _market = nil
      
      if (keyword = m_log['keyword']) && (keyword_lookup.key(keyword))
        _market = keyword_lookup.key(keyword)
      end

      if !_market && (tracking_number = m_log['tracking_number']) && tracking_number_lookup.key(tracking_number)
        _market = tracking_number_lookup.key(tracking_number)
      end

      market == _market
    end
    _mongoose_logs
  end

end