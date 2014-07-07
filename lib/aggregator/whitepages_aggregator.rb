class Aggregator::WhitepagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose mongoose_logs, logs
    # logs are not important for this vendor
    # all mongoose logs that have the given destination number are for whitepages
    mongoose_logs.select do |m_log| 
      m_log['destination_number'] == '9993140955'
    end
  end

end