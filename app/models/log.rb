class Log
  require "redis"

  ATTRIBUTES = [:date, :media_channel, :media_type, :market, :impressions, 
                :clicks, :cost, :calls, :napt, :nfam, :eapt, :unique_id, :vendor]

  attr_accessor *ATTRIBUTES

  attr_reader :aggregator

  def initialize(aggregator)
    @aggregator = aggregator
    set_values unless aggregator.has_many_rows
  end

  def get_logs
    aggregator.has_many_rows ? aggregator.rows : [get_values]
  end

  def set_values
    ATTRIBUTES.each do |attr|
      self.send("#{attr.to_s}=".to_sym, aggregator.send("get_#{attr.to_s}".to_sym))
    end
    self.unique_id = "#{self.vendor}_#{self.date}_#{self.media_channel}_#{self.media_type}_#{self.market}"
    self
  end

  def get_values
    {
      id: self.unique_id,
      date: self.date,
      vendor: self.vendor,
      media_channel: self.media_channel,
      media_type: self.media_type,
      market: self.market,
      impressions: self.impressions,
      clicks: self.clicks,
      cost: self.cost,
      calls: self.calls,
      napt: self.napt,
      nfam: self.nfam,
      eapt: self.eapt
    }
  end
  
  def self.find_log_rows_for_day date
    key = date.strftime('%Y-%m-%d')
    if row = $redis.get("main:#{key}")
      JSON.parse row
    else
      nil
    end
  end

  def self.save_log_rows log_rows, date
    $redis.set("main:#{date.strftime('%Y-%m-%d')}", log_rows.map(&:get_values).to_json)
  end

end