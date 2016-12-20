require 'cgi'
require 'ctct_smd/ctct_smd_config'

module CTCT_SMD  
  module Rendering    

    require 'time'

    def html_format(str, truncate=false)
      str = CGI::escapeHTML(str)   
      if truncate
        str = str.length > max_length ? str[0..max_length] + "...(truncated)" : str
      end
      str.gsub!("\n","<br />")
      str
    end

    def max_length
      @max_length || CTCT_SMD.config[:feed_formatted_msg_length]
    end
  end
end
