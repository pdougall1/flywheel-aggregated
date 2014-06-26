class Lookup::GoogleBingLookup < Lookup::GeneralLookup

  def self.market
    YAML.load(File.open(path "google_bing_market"))
  end

end
