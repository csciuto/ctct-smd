require 'timecop'
require 'config_helper'
require 'ctct_smd/constantcontact_client'

RSpec.describe CTCT_SMD::ConstantContactClient do

  context "#create_campaign" do

    let(:response) { JSON.generate({ parses: 'as valid json' }) }

    before do
      Timecop.freeze(Time.now)

      stub_request(:post,
        "https://api.constantcontact.com/v2/emailmarketing/campaigns"\
            "?access_token=dummy_constantcontact_token&api_key=dummy_constantcontact_key"
        ).with(
        :body => "{\"email_content_format\":\"XHTML\",\"email_content\":\"<html>body ?here Al?s</html>\","\
            "\"from_email\":\"test@example.com\",\"from_name\":\"Test Sender\",\"name\":"\
            "\"Automated Campaign: #{Time.now.to_s}\",\"reply_to_email\":\"test@example.com\","\
            "\"subject\":\"Social Media Digest\","\
            "\"sent_to_contact_lists\":[{\"id\":\"999\"}],"\
            "\"text_content\":\"<text>Please view this email in an HTML-capable mail client</text>\","\
            "\"is_view_as_webpage_enabled\":true,\"view_as_web_page_link_text\":\"here\","\
            "\"view_as_web_page_text\":\"View this message as a web page\","\
            "\"is_permission_reminder_enabled\":true,\"permission_reminder_text\":"\
            "\"Hi, just a reminder that you're receiving this email because you have expressed an "\
            "interest in <Property name='Account.OrganizationName'/>. Don't forget to add "\
            "<Property name='Account.SignatureEmail'/> to your address book so we'll be sure to land in your inbox!\","\
            "\"greeting_name\":\"FIRST_AND_LAST_NAME\",\"greeting_salutations\":\"Hi\","\
            "\"style_sheet\":\".fakecss {align: center}\"}"

          ).to_return(status: 201, body: response, headers: {})
    end

    it "strips unicode and returns parsed json" do
      result = CTCT_SMD::ConstantContactClient.new.create_campaign("<html>body \u1010here Al\u00e9s</html>",".fakecss {align: center}")
      expect(result).not_to be_nil
    end

    after do
      Timecop.return
    end
  end

end
