module CTCT_SMD
  
  def self.config
    unless @config
      @config = {

        feed_formatted_msg_length: 255,

        facebook_token: "{facebook_token}",
        facebook_page_limit: 10,        
        facebook_page_since_days: 7,
        facebook_template: File.join(File.dirname(__FILE__),'facebook/facebook.erb'),

        constantcontact_key: "{constantcontact_key}",
        constantcontact_token: "{constantcontact_token}",
        constantcontact_reply_email: "{constantcontact_reply_email}",
        constantcontact_from_email: "{constantcontact_from_email}",
        constantcontact_from_name: "{constantcontact_from_name}",
        constantcontact_subject: "{constantcontact_subject}",
        constantcontact_salutation: "Hi",
        
        constantcontact_email_template: File.join(File.dirname(__FILE__),'email_template.erb'),
        constantcontact_style_sheet: File.join(File.dirname(__FILE__),'style_sheet.css'),
        constantcontact_img: "{constantcontact_img}",
        constantcontact_message: "News Digest from Social Media"
        
      }
    end
    @config
  end

  def self.config=(config) 
    @config = config
  end
end
