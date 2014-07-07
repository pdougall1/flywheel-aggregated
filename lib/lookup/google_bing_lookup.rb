class Lookup::GoogleBingLookup < Lookup::GeneralLookup

  def self.market
    YAML.load(File.open(path "google_bing_market"))
  end

  def self.market_to_keyword
    YAML.load(File.open(path "google_bing_market_to_keyword"))
  end

  def self.market_to_tracking_number
    YAML.load(File.open(path "google_bing_tracking_number_to_market"))
  end

  def self.parsed_keyword_to_market
    YAML.load(File.open(path "google_bing_parsed_keyword_to_market"))
  end

end
