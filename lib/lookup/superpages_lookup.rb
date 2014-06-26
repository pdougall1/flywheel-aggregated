class Lookup::SuperpagesLookup < Lookup::GeneralLookup

  def self.ad_name_to_market
    YAML.load(File.open(path "superpages_ad_name_to_market"))
  end

  def self.market_to_keyword
    YAML.load(File.open(path "superpages_market_to_keyword"))
  end

  def self.market_to_tracking_number
    YAML.load(File.open(path "superpages_market_to_tracking_number"))
  end

end
