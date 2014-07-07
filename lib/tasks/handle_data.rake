namespace :data do

  task :remove_ad_view_logs, [:begin_date, :end_date, :vendors => [:environment] do |t, args|
    # vendors = ['google', 'bing', 'marchex']
    args[:vendors].each do |vendor|
      logs = AdViewLog.where("date >= ? AND date <= ? AND vendor = ?", ars[:begin_date], ars[:end_date], vendor)
      reports = logs.reduce([]) do |acc, log|
        acc << log.report unless acc.include? log.report
      end
      reports.each do |r|
        r.logs.delete_all
        r.delete
      end
    end
  end

end
