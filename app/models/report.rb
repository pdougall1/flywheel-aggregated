class Report

  REPORT_HEADERS = ["id", "date", "vendor", "media_channel", "media_type",
                    "market", "impressions", "clicks", "cost", "calls", "napt",
                    "nfam", "eapt"]

  include SendFTP

  def build_report(date_range)
    
    date_range = date_range.map(&:to_s) if date_range.is_a? Range
    date_range = [date_range] unless date_range.is_a? Array
    rows = date_range.map do |date|
      date = date.to_s unless date.is_a? String
      logs = $redis.get(date)
      JSON.parse(logs) if logs
    end.flatten.compact

    unless rows.empty?
      csv_string = CSV.generate do |csv|
        headers = REPORT_HEADERS
        csv << headers
        rows.each { |row| csv << headers.map { |h| row[h] } }
      end
    end
    csv_string
  end

  def send_report(date_range)
    csv_string = build_report(date_range)
    file = Tempfile.new('foo')
    file.write(csv_string)
    add_file file
  end

end


# r = Report.new.build_report(Date.parse('2014-05-26')..Date.parse('2014-06-01'))
# File.open('/Users/look-listendev4/Desktop/report_2.csv', 'w') { |f| f.write r }


