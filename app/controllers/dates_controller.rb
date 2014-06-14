class DatesController < ApplicationController

  def update
    dates = params[:dates][:new]
    reciever = Reciever.new JSON.parse(dates)
    reciever.handle_dates 
  end

end
