module Lookup

  class GeneralLookup
    def self.path data_source
      Rails.root.to_path + "/lib/lookup/tables/#{data_source}.yaml"
    end
  end

end

