class Aggregator::SuperpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose mongoose_logs, logs
    market = logs.first['market'] || 'none'
    keyword_lookup = Lookup::SuperpagesLookup.market_to_keyword
    tracking_number_lookup = Lookup::SuperpagesLookup.market_to_tracking_number
    _mongoose_logs = mongoose_logs.select do |m_log|
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