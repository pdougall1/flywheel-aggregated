module Aggregator

  def self.build_log_row vendor, logs, mongoose_logs, braxtel_logs
    agg = "Aggregator::#{vendor.to_constant_string}Aggregator".constantize.new logs, mongoose_logs, braxtel_logs
    agg.log_row 
  end

  class Aggregator::GeneralAggregator

    def initialize logs, mongoose_logs, braxtel_logs
      @date = logs.first['date']
      if self.class.to_s.include? 'Marchex'
        @braxtel_logs = braxtel_logs.select { |l| l['destination_number'] == '3177595209' }
        caller_ids = @braxtel_logs.map { |l| l['caller_id'] }
        @mongoose_logs = mongoose_logs.select do |m_log|
          caller_ids.include? m_log['caller_id'] 
        end
      else
        @mongoose_logs = get_mongoose(mongoose_logs, logs) 
        @braxtel_logs = @mongoose_logs.map do |m_log| 
          braxtel_logs.select do |b_log| 
            b_log['caller_id'] == m_log['caller_id'] 
          end
        end.flatten
        # debugger if self.class == Aggregator::CitygridAggregator
      end
      @logs = logs
    end

    def log_row
      Log.new(self, @logs)
    end

    def get_clicks logs
      logs.map {|l| l['clicks'].to_i}.reduce(:+)
    end

    def get_cost logs
      logs.reduce(0) do |acc, l|
        acc = $math.add(acc, l['cost'].to_f)
        acc
      end
    end

    def get_impressions logs
      logs.map {|r| r['impressions'].to_i}.reduce(:+)
    end

    def get_calls logs
      @mongoose_logs.reduce(0) do |acc, m_log|
        acc += 1 if m_log['call_duration'].to_i >= 60
        acc
      end
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

    def get_mongoose mongoose_logs, logs
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