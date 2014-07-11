class DougsCSVImporter

  attr_reader :file_string, :headers

  def initialize(filename, headers = nil, path_prefix = "/Users/look-listendev4/Desktop")
    path = [path_prefix, filename].join('/')
    @file_string = File.open(path).read
    @headers = headers
  end

  def parse
    DougsCSV.parse(file_string, headers)
  end

end