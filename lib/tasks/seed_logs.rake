namespace :logs do

  task seed: :environment do
    Reciever.new((Date.today - 2.months..Date.today).map(&:to_s)).handle_dates
  end

end