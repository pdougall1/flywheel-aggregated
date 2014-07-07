namespace :logs do

  task seed: :environment do
    Reciever.new((Date.today - 1.months..Date.today).map(&:to_s)).handle_dates
  end

end