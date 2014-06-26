class Lookup::YellowpagesLookup < Lookup::GeneralLookup

  def self.market
    YAML.load(File.open(path "yellowpages_market"))
  end

end
