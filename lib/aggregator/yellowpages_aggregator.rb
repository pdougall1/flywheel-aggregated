class Aggregator::YellowpagesAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    logs.map { |log| MongooseLog.find_by_caller_id(log.customer) }.flatten.compact
  end

end