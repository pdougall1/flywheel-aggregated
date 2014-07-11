require 'csv'

class DougsCSV

  def self.make_csv(objects, headers = nil)
    sample = objects.first
    if _headers = sample.try(:attributes)
      csv_from_active_record_object objects, _headers
    elsif sample.is_a? Array
      csv_from_arrays objects, headers
    elsif sample.is_a? Hash
      csv_from_hash objects
    end
  end

  def self.csv_from_active_record_object objects, headers
    CSV.generate do |csv|
      csv << headers
      objects.each do |obj|
        csv << obj.attributes.values_at(*headers)
      end
    end
  end

  def self.csv_from_arrays(arrs, headers)
    CSV.generate do |csv|
      csv << headers if headers
      for i in arrs.length
        csv << arrs.map { |r| r[i] }
      end
    end
  end

  def self.csv_from_hash objects
    CSV.generate do |csv|
      csv << objects.first.keys
      objects.each do |obj|
        csv << obj.values
      end
    end
  end

  def self.parse(csv_string, headers = nil)
    csv = CSV.parse(csv_string, col_sep: ",", headers: false)
    headers ||= csv[0]
    after_headers = find_headers_index(csv, headers) +1
    body = csv[after_headers..-1]
    rows = []
    body.each do |row|
      new_row = {}
      headers.each.with_index { |h, i| new_row[h] = row[i] }      
      rows << new_row
    end
    rows
  end

  def self.find_headers_index csv, headers
    index = -1
    csv.each.with_index do |row, i|
      index = i if ((row & headers).length / headers.length.to_f) > 0.75
    end
    index
  end

end