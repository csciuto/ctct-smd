require 'ctct_smd/ctct_smd_config'

CTCT_SMD.config.merge!({
  facebook_token: 'dummy_facebook_token',
  constantcontact_key: 'dummy_constantcontact_key',
  constantcontact_token: 'dummy_constantcontact_token',
  constantcontact_reply_email: 'test@example.com',
  constantcontact_from_email: 'test@example.com',
  constantcontact_from_name: 'Test Sender',
  constantcontact_subject: 'Social Media Digest',
  feed_formatted_msg_length: 25
})
