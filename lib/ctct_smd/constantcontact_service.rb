require 'erb'
require 'ctct_smd/ctct_smd_config'
require 'ctct_smd/constantcontact_client'

module CTCT_SMD
  class ConstantContactService
    
    # Takes the html-formatted feeds passed in and parses them through the email template and stylesheet.
    def send_email(feeds, send=true)
      template = ERB.new(File.read(CTCT_SMD.config[:constantcontact_email_template]))
      campaign_html = template.result(binding)      
      campaign_json = client.create_campaign(campaign_html, style_sheet)
      CTCT_SMD.logger.info("Created campaign id #{campaign_json['id']} : #{campaign_json['name']}")
      if send
        schedule_json = client.schedule(campaign_json['id'])
        CTCT_SMD.logger.info("Campaign campaign id #{campaign_json['id']}:#{schedule_json['id']} scheduled for #{schedule_json['scheduled_date']}")
      end
    end

    def get_lists
      client.get_lists
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
