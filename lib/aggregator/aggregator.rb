module Aggregator

  def build_log_row vendor, logs, mongoose_logs, braxtel_logs
    agg = "Aggregator::#{vendor.to_constant_string}Aggregator".constantize.new logs, mongoose_logs, braxtel_logs
    agg.log_row
  end

  class Aggregator::GeneralAggregator

    attr_reader :logs, :all_mongoose_logs, :all_braxtel_logs, :rows

    def initialize(logs, mongoose_logs, braxtel_logs)
      @all_mongoose_logs = mongoose_logs
      @all_braxtel_logs  = braxtel_logs
      @date = logs.first['date']
      @market = logs.first['market']
      @logs = logs
    end

    def mongoose_logs
      @mongoose_logs ||= get_mongoose
    end

    def get_mongoose
      @all_mongoose_logs
    end

    def braxtel_logs
      @braxtel_logs ||= get_braxtel
    end

    def get_braxtel
      _b_logs = all_braxtel_logs
      _b_logs.keep_if { |l| l['destination_number'] == destination_number } if destination_number
      @braxtel_logs = mongoose_logs.map do |m_log| 
        _b_logs.select do |b_log| 
          b_log['caller_id'] == m_log['caller_id'] 
        end
      end.flatten
    end

    def log_row
      Log.new(self)
    end

    def get_clicks 
      logs.map {|l| l['clicks'].to_i}.reduce(:+)
    end

    def get_cost 
      logs.reduce(0) do |acc, l|
        acc = $math.add(acc, l['cost'].to_f)
        acc
      end
    end

    def get_impressions 
      logs.map {|r| r['impressions'].to_i}.reduce(:+)
    end

    def get_calls 
      mongoose_logs.reduce(0) do |acc, m_log|
        acc += 1 if m_log['call_duration'].to_i >= 60
        acc
      end
    end

    def get_unique_id 
      logs.first['sorting_id']
    end

    def get_date 
      logs.first['date']
    end

    def get_media_channel 
      logs.first['media_channel']
    end

    def get_media_type 
      logs.first['media_type']
    end

    def get_market 
      logs.first['market']
    end

    def get_vendor 
      logs.first['vendor']
    end

    def get_napt 
      braxtel_logs.reduce(0) { |sum, log| sum += log['napt'].to_i; sum }
    end

    def get_nfam 
      braxtel_logs.reduce(0) { |sum, log| sum += log['nfam'].to_i; sum }
    end

    def get_eapt 
      braxtel_logs.reduce(0) { |sum, log| sum += log['eapt'].to_i; sum }
    end

    def destination_number
      nil
    end

    def has_many_rows
      false
    end

  end

end