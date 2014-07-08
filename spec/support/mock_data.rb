class MockData

  def self.get_file(vendor_name, type = 'json')
    file = File.open(Rails.root.to_s + "/spec/mock_data/#{vendor_name}_json.#{type}")
    JSON.parse(file.read)
  end

end