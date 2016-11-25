require 'erb'
require 'ctct_smd/ctct_smd_config'
require 'ctct_smd/constantcontact_client'

module CTCT_SMD
  class ConstantContactService
    
    # Takes the html-formatted feeds passed in and parses them through the email template and stylesheet.
    def send_email(feeds)
      template = ERB.new(File.read(CTCT_SMD.config[:constantcontact_email_template]))
      campaign_html = template.result(binding)      
      client.create_campaign(campaign_html, style_sheet)
    end

  private

    def client
      @client ||= ConstantContactClient.new
    end

    def style_sheet
      @style_sheet ||= File.read(CTCT_SMD.config[:constantcontact_style_sheet])
    end
  end
end
