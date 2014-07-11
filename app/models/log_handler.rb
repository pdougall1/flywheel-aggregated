class LogHandler

  extend Aggregator

  def self.build_logs(data, dates)
    date = data.keys[0]
    data = data.values[0]
    rows = []
    b_logs = [data["braxtel_logs"]].flatten
    m_logs = data["mongoose_logs"]
    sort(data["ad_view_logs"]).each do |k, logs|
      vendor_name = k.split('_')[0]
      log = build_log_row(vendor_name, logs, data["mongoose_logs"], data["braxtel_logs"])
      rows += log.get_logs  
    end

    logs = [{ 
      'vendor' => 'whitepages',
      'date' => date.to_s,
      'media_channel' => 'unavailable',
      'media_type' => 'unavailable',
      'market' => 'unavailable'
    }]
    log = build_log_row('whitepages', logs, m_logs, b_logs)
    rows += log.get_logs

    if $redis.set(date, rows.to_json)
      puts "SAVED : #{date}"
    else
      puts "COULDNT SAVE #{key}"
    end
  end

  def self.find_logs(dates)
    dates = [dates] unless dates.is_a? Array
    dates.map do |date|
      JSON.parse $redis.get(date) if $redis.get(date)
    end.flatten.compact
  end

  def self.sorting_id(log)
    "#{log['vendor']}_#{log['date']}_#{log['media_channel']}_#{log['media_type']}_#{log['market']}"
  end

  def self.sort(logs)
    logs.reduce({}) do |acc, log|
      id = sorting_id log
      acc[id] ? acc[id] << log : acc[id] = [log]
      acc
    end
  end

end

