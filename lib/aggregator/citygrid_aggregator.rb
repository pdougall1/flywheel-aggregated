class Aggregator::CitygridAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    # testing_log = "count : #{logs.count}, date: #{@date} markets : #{logs.map(&:market)}"
    # File.open("/Users/look-listendev4/Projects/look-listen/client-data/log/processor_logs/citygrid_aggrigator.txt", 'a') {|f| f.puts testing_log}
    keywords = Lookup::CitygridLookup.market_to_keyword[logs.first.market]
    keywords.map { |key| MongooseLog.where("keyword = ? AND date = ?", key, @date)}.flatten.compact
  end

end
