class Lookup::YellowpagesLookup < Lookup::GeneralLookup

  def self.market
    YAML.load(File.open(path "yellowpages_market"))
  end

  def self.market_to_tracking_number
    YAML.load(File.open(path "yellowpages_market_to_tracking_number"))
  end

end
