require 'net/ftp'
require 'csv'

module SendFTP
  extend ActiveSupport::Concern

  # SERVER_DOMAIN = ENV['KS_FTP_SERVER_DOMAIN']
  # FTP_USERNAME = ENV['KS_FTP_USERNAME']
  # FTP_PASSWORD = ENV['KS_FTP_PASSWORD']

  SERVER_DOMAIN = ENV['FTP_SERVER_DOMAIN']
  FTP_USERNAME = ENV['FTP_USERNAME']
  FTP_PASSWORD = ENV['FTP_PASSWORD']
  FTP_DIR = "/reporting.look-listen.com/web/content/csv"

  def add_file file
    open_connection.puttextfile file
    close
  end

  def delete_file file_name
    open_connection.delete file_name
    close
  end

  private

  def open_connection
    unless @connection
      @connection = Net::FTP.new(SERVER_DOMAIN)
      @connection.passive = true
      @connection.login(FTP_USERNAME, FTP_PASSWORD)
    end
    @connection
  end

  def close
    @connection.close
    @connection = nil
  end

end

