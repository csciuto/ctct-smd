require 'net/http'
require 'json'
require 'ctct_smd/ctct_smd_logger'
require 'ctct_smd/ctct_smd_config'

module CTCT_SMD
  class ConstantContactClient

    V2_API_BASE = 'https://api.constantcontact.com/v2/'

    def create_campaign(html_body, style_sheet)
      request_body = generate_request_body(html_body, style_sheet)
      post(
        "emailmarketing/campaigns",
        request_body
      )
    end

    def schedule(campaign_id)
      post(
        "emailmarketing/campaigns/#{campaign_id}/schedules"
      )
    end

  private

    def post(relative_uri, request_body='{}')

      #Unfortunately, CTCT is not unicode...
      request_body.encode!("US-ASCII", :undef => :replace, :invalid => :replace)

      uri = URI(V2_API_BASE + relative_uri)
      CTCT_SMD.logger.debug("POST #{uri}, #{request_body}")
      uri.query = URI.encode_www_form(ctct_key.merge(ctct_token))
      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        http.request(req, request_body)
      end
      CTCT_SMD.logger.debug("#{response.code}\n#{response.body}")
      JSON.parse(response.body)
    end

    def generate_request_body(html_body, style_sheet)
       JSON.generate({
        'email_content_format' => 'XHTML',
        'email_content' => html_body,
        'from_email' => ctct_from_email,
        'from_name' => ctct_from_name,
        'name' => "Automated Campaign: #{Time.now.to_s}",
        'reply_to_email' =>  ctct_reply_email,
        'subject' => ctct_subject,
        'sent_to_contact_lists' => [
          { 'id': CTCT_SMD.config[:constantcontact_list] }
        ],
        'text_content' => '<text>Please view this email in an HTML-capable mail client</text>',
        'is_view_as_webpage_enabled' => true,
        'view_as_web_page_link_text' => 'here',
        'view_as_web_page_text' => 'View this message as a web page',
        'is_permission_reminder_enabled' => true,
        'permission_reminder_text' => "Hi, just a reminder that you're receiving this email "\
          "because you have expressed an interest in <Property name='Account.OrganizationName'/>. "\
          "Don't forget to add <Property name='Account.SignatureEmail'/> "\
          "to your address book so we'll be sure to land in your inbox!",
        "greeting_name" => "FIRST_AND_LAST_NAME",
        "greeting_salutations" => CTCT_SMD.config[:constantcontact_salutation],
        "style_sheet" => style_sheet
      })
    end

    def ctct_key
      @ctct_key ||= { api_key: CTCT_SMD.config[:constantcontact_key] }
    end

    def ctct_token
      @ctct_token ||= { access_token: CTCT_SMD.config[:constantcontact_token] }
    end

    def ctct_reply_email
      @ctct_reply_email ||= CTCT_SMD.config[:constantcontact_reply_email]
    end

    def ctct_from_email
      @ctct_from_email ||= CTCT_SMD.config[:constantcontact_from_email]
    end

    def ctct_from_name
      @ctct_from_name ||= CTCT_SMD.config[:constantcontact_from_name]
    end

    def ctct_subject
      @ctct_subject ||= CTCT_SMD.config[:constantcontact_subject]
    end
  end
end
