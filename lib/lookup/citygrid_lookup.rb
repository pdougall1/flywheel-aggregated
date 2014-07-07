class Lookup::CitygridLookup < Lookup::GeneralLookup

  def self.market
    YAML.load(File.open(path 'citygrid_market'))
  end

  def self.market_to_keyword
    YAML.load(File.open(path 'citygrid_market_to_keyword'))
  end

  def self.market_to_tracking_number
    YAML.load(File.open(path 'citygrid_market_to_tracking_number'))
  end

end
