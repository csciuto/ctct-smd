require 'logger'
require 'fileutils'

module CTCT_SMD  
  
  def self.logger
    unless @logger
      FileUtils.mkdir 'log' unless File.exist? 'log'

      @logger = Logger.new('log/ctct_smd.log', 10, 1024000)
      @logger.level = Logger::INFO
      
      original_formatter = Logger::Formatter.new
      @logger.formatter = proc do |severity, datetime, progname, msg|
        original_formatter.call(severity, datetime, progname, msg.dump)
      end
    end

    @logger
  end


  def self.logger=(logger)
    @logger = logger
  end
end
