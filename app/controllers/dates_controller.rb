class DatesController < ApplicationController

  def update
    dates = params[:dates][:new]
    reciever = Reciever.new(JSON.parse(dates))
    reciever.handle_dates 
  end

  def index
    dates = (Date.parse(params[:beginning])..Date.parse(params[:ending])).map(&:to_s)
    debugger
    logs = LogHandler.new.find_logs(dates)
    render json: { logs: logs}
  end

end
