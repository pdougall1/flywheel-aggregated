class DatesController < ApplicationController

  def update
    dates = params[:dates][:new]
    reciever = Reciever.new(JSON.parse(dates))
    reciever.handle_dates 
  end

  def index
    dates = params[:dates]
    handler = LogHandler.new
    logs = handler.find_logs(dates)
    render json: logs
  end

end
