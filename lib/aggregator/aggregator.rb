module Aggregator

  def self.build_log_row vendor, logs, mongoose_logs, braxtel_logs
    agg = "Aggregator::#{vendor.to_constant_string}Aggregator".constantize.new logs, mongoose_logs, braxtel_logs
    agg.log_row 
  end

  class Aggregator::GeneralAggregator

    def initialize logs, mongoose_logs, braxtel_logs
      @date = logs.first['date']
      @mongoose_logs = mongoose_logs
      @braxtel_logs = braxtel_logs
      # @braxtel_logs  = @mongoose_logs.map do |log| 
      #   braxtel_logs.select do |l| 
      #     l['caller_id'] == log['caller_id'] && 
      #     l['date'] == @date }.flatten
      #   end
      # end
      @logs = logs
    end

    def log_row
      # napt_count = self.get_napt @logs 
      # nfam_count = self.get_nfam @logs 
      # eapt_count = self.get_eapt @logs 
      # total = napt_count + nfam_count + eapt_count
      # test_log = total > 0 ? "napt : #{napt_count}, nfam : #{nfam_count}, eapt : #{eapt_count}" : nil
      # File.open("/Users/look-listendev4/Projects/look-listen/client-data/log/processor_logs/citygrid_aggrigator.txt", 'a') {|f| f.puts test_log}
      Log.new(self, @logs)
    end

    def get_clicks logs
      logs.map {|l| l['clicks'].to_i}.reduce(:+)
    end

    def get_cost logs
      logs.map {|l| l['cost'].to_i}.reduce(:+)
    end

    def get_impressions logs
      logs.map {|r| r['impressions'].to_i}.reduce(:+)
    end

    def get_calls logs
    end

    def get_unique_id logs
      logs.first['sorting_id']
    end

    def get_date logs
      logs.first['date']
    end

    def get_media_channel logs
      logs.first['media_channel']
    end

    def get_media_type logs
      logs.first['media_type']
    end

    def get_market logs
      logs.first['market']
    end

    def get_vendor logs
      logs.first['vendor']
    end

    def get_mongoose_logs logs
      puts "need to define this method on the class specific aggregator"
      []
    end

    def get_napt logs
      @braxtel_logs.reduce(0) { |sum, log| sum += log['napt'].to_i; sum }
    end

    def get_nfam logs
      @braxtel_logs.reduce(0) { |sum, log| sum += log['nfam'].to_i; sum }
    end

    def get_eapt logs
      @braxtel_logs.reduce(0) { |sum, log| sum += log['eapt'].to_i; sum }
    end

  end

end