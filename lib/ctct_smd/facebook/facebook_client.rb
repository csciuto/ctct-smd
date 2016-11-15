require 'net/http'
require 'json'
require 'ctct_smd/ctct_smd_logger'
require 'ctct_smd/ctct_smd_config'

module CTCT_SMD
  class FacebookClient

    GRAPH_BASE = 'https://graph.facebook.com/v2.8/'

    def get_page(page_id)
      get(
        "#{page_id}"
      )
    end

    def get_page_posts(page_id)
      get(
        "#{page_id}/posts",
        {
          fields: 'story,message,created_time,updated_time,permalink_url,shares,link,name,caption,description,picture',
          limit: CTCT_SMD.config[:facebook_page_limit],
          since: start_time
        }
      )
    end

    def get_page_post_reactions(post_id)
      get(
        "#{post_id}/reactions",
        {
          summary: 'true',
          fields: 'total_count'
        }
      )
    end

    def get_page_post_comments(post_id)
      get(
        "#{post_id}/comments",
        {
          summary: true,
          fields: 'total_count',
          filter: 'stream'
        }
      )
    end

    def get_group_posts(group_id)
      get(
        "#{group_id}/feed",
        {
          fields: 'story,message,created_time,updated_time,permalink_url,shares,link,name,caption,description,picture',
          limit: CTCT_SMD.config[:facebook_page_limit],
          since: start_time
        }
      )
    end

    def get_group_post_reactions(post_id)
      get(
        "#{post_id}/reactions",
        {
          summary: 'true',
          fields: 'total_count'
        }
      )
    end

    def get_group_post_comments(group_id, post_id)
      get(
        "#{post_id}/comments",
        {
          summary: 'total_count',
          filter: 'stream'
        }
      )
    end

  private

    def get(relative_uri, params={})
      uri = URI(GRAPH_BASE + relative_uri)
      CTCT_SMD.logger.debug("GET #{uri}, #{params}")
      uri.query = URI.encode_www_form(params.merge(facebook_token))
      response = Net::HTTP.get_response(uri)
      CTCT_SMD.logger.debug("#{response.code}\n#{response.body}")
      JSON.parse(response.body)
    end

    def start_time
      (Time.now - (CTCT_SMD.config[:facebook_page_since_days] * 24 * 60 * 60)).to_i
    end

    def facebook_token
      @facebook_token ||= { access_token: CTCT_SMD.config[:facebook_token] }
    end
  end
end
