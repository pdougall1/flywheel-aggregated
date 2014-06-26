class Aggregator::CitygridAggregator < Aggregator::GeneralAggregator

  def get_mongoose_logs logs
    keywords = Lookup::CitygridLookup.market_to_keyword[logs.first['market']]
    keywords.reduce([]) do |acc, key| 
      acc << @mongoose_logs.select { |l| l['keyword'] == key && l['date'] == @date }
      acc
    end
  end

end
