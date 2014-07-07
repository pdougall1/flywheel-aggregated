require 'net/http'

class Reciever

  AVAILABLE_TYPES = ['all_logs']

  def initialize dates, type = 'all_logs'
    dates = [dates] if dates.is_a? String
    if valid_format? dates
      @dates = dates
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
    m_logs = []
    a_logs = []
    @dates.each do |date|
      if Rails.env == 'development'
        store_url = 'http://localhost:3001'
      elsif Rails.env == 'production'
        store_url = 'http://flywheel-store.herokuapp.com'
      end
      uri = URI.parse([store_url, @type, date].join('/'))
      logs = get_logs uri
      m_logs << logs.values.first['mongoose_logs']
      a_logs << logs.values.first['ad_view_logs']
      process logs
      # a_logs.flatten.map { |l| l['market'] }
      debugger
      # puts 'LOGS PROCESSED'
    end
    debugger
    puts 'dougs'
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
    logs = LogHandler.build_logs logs
  end

  def update sorted_logs
    logs = []
    sorted_logs.each do |id, _logs|
      vendor_name = id.split("_")[0]
      logs << Aggregator.build_log_row(vendor_name, _logs)
    end
    logs.each(&:save)
  end

end





# Reciever.new((Date.parse('2014-05-26')..Date.parse('2014-06-01')).map(&:to_s)).handle_dates








