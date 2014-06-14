class Reciever

  AVAILABLE_TYPES = ['all_logs']

  def initialize dates, type = 'all_logs'
    if valid_format? dates
      @dates = dates.is_a?(Array) ? dates : [dates]
    else
      return 'invalid date format'
    end
    return unless AVAILABLE_TYPES.include? type
    @type = type
  end

  def valid_format? dates
    dates.each do |date|
      begin
        Date.parse(date)
        true
      rescue
        return false
      end
    end
  end

  def handle_dates
    @dates.each do |date|
      uri = URI.parse("http://localhost:3000/#{@type}/#{date}")
      logs = get_logs uri
      process logs
    end
  end

  def get_logs uri
    http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    # request.basic_auth(ID, PASSWORD)
    response = http.request(request)
    JSON.parse response.body
  end

  def process logs
    puts 'still need to process'
    # sorted_logs = sort logs
    # update sorted_logs
  end

  def sort logs
    logs.reduce({}) do |acc, log|
      id = sorting_id log
      acc[id] ? acc[id] << log : acc[id] = [log]
    end
  end

  def sorting_id log
    "#{log['vendor']}_#{log['date'].strftime('%d-%m-%Y')}_#{log['media_channel']}_#{log['media_type']}_#{log['market']}"
  end

  def update sorted_logs
    logs = []
    sorted_logs.each do |id, _logs|
      vendor_name = id.split("_")[0]
      logs << Aggregator.build_log_row(vendor_name, _logs)
    end
    logs.each(&:save)
    # Assessment.new({ beginning: date_range.first, ending: date_range.last }).update_tables
  end

end





