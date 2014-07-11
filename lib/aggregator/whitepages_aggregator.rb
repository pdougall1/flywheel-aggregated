class Aggregator::WhitepagesAggregator < Aggregator::GeneralAggregator

  def initialize(logs, mongoose_logs, braxtel_logs)
    super
    @rows = []
    build_rows
  end

  def destination_number
    '9793140955'
  end

  def included_braxtel_logs
    @included_braxtel_logs ||= all_braxtel_logs.select do |b_log|
      b_log['destination_number'] == destination_number
    end
  end

  def build_rows
    caller_ids = included_braxtel_logs.map { |b_log| b_log['caller_id'] }.uniq
    lookup = Lookup::WhitepagesLookup.tracking_number_to_market

    m_logs = all_mongoose_logs.select do |m_log|
      caller_ids.include? m_log['caller_id']
    end

    m_log_groups = m_logs.group_by { |m_log| lookup[m_log['tracking_number']] }

    m_log_groups.each do |market, group|
      @market = market
      @braxtel_logs = group.map do |m_log| 
        included_braxtel_logs.select do |b_log| 
          b_log['caller_id'] == m_log['caller_id']
        end
      end.flatten

      @_mongoose_logs = group
      row = {
        id: self.get_unique_id,
        date: self.get_date,
        vendor: self.get_vendor,
        media_channel: self.get_media_channel,
        media_type: self.get_media_type,
        market: @market,
        impressions: self.get_impressions,
        clicks: self.get_clicks,
        cost: self.get_cost,
        calls: self.get_calls,
        napt: self.get_napt,
        nfam: self.get_nfam,
        eapt: self.get_eapt
      }
      @rows << row
    end

  end



    def get_cost
      @_mongoose_logs.reduce(0) do |acc, m_log|
        acc += 1 if m_log['call_duration'].to_i >= 30  
        acc
      end * 12
    end

    def get_vendor
      'whitpages'
    end

    def get_clicks 
      get_calls
    end

    def get_impressions 
      "N/A"
    end

    def get_calls 
      @_mongoose_logs.reduce(0) do |acc, m_log|
        acc += 1 if m_log['call_duration'].to_i >= 60
        acc
      end
    end

    def get_unique_id 
      "#{get_vendor}_#{get_date}_#{get_media_channel}_#{get_media_type}_#{@market}"
    end

    def get_date 
      logs.first['date']
    end

    def get_media_channel 
      "White Pages"
    end

    def get_media_type 
      "Directory"
    end

    def has_many_rows
      true
    end


end