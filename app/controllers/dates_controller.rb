class DatesController < ApplicationController

  def update
    dates = params[:dates][:new]
    reciever = Reciever.new(JSON.parse(dates))
    reciever.handle_dates 
  end

  def index
    ending = params[:ending] ? Date.parse(params[:ending]) : Date.today
    beg = params[:beginning] ? Date.parse(params[:beginning]) : ending - 2.months
    dates = (beg..ending).map(&:to_s)
    logs = LogHandler.new.find_logs(dates)
    render json: { logs: logs}
  end

end
