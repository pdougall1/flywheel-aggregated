class Lookup::WhitepagesLookup < Lookup::GeneralLookup

  def self.tracking_number_to_market
    YAML.load(File.open(path "whitepages_tracking_number_to_market"))
  end

end
