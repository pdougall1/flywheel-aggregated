class LogHandler

  extend Aggregator

  def self.build_logs(data)
    date = data.keys[0]
    data = data.values[0]
    rows = []
    sort(data["ad_view_logs"]).each do |k, logs|
      vendor_name = k.split('_')[0]
      row = build_log_row(vendor_name, logs, data["mongoose_logs"], data["braxtel_logs"])
      rows << row.get_values
    end
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

