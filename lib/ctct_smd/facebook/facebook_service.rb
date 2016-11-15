module CTCT_SMD
  class FacebookService

    # For the given page_id, retrieve the page then retrieve the list of posts.
    # For each post, retrieve the number of comments and reactions
    # Return a Struct with the values of the page_name and the array of posts
    def get_page(page_id)
      page_name = facebook_client.get_page(page_id)['name']
      raw_posts = facebook_client.get_page_posts(page_id)['data']

      posts = []

      raw_posts.each do |raw_post|
        post = {}

        post['story'] = raw_post['story']
        post['message'] = raw_post['message']
        post['created_time'] = raw_post['created_time']
        post['updated_time'] = raw_post['updated_time']
        post['permalink_url'] = raw_post['permalink_url']

        if raw_post['link']
          post['link'] = {}.tap do |link|
            link['url'] = raw_post['link']
            link['name'] = raw_post['name']
            link['caption'] = raw_post['caption']
            link['description'] = raw_post['description']
            link['picture'] = raw_post['picture']
          end
        end

        post['shares'] = raw_post['shares'] ? raw_post['shares']['count'] : 0

        post_id = raw_post['id']

        post['reactions'] = facebook_client.get_page_post_reactions(post_id)['summary']['total_count']
        post['comments'] = facebook_client.get_page_post_comments(post_id)['summary']['total_count']

        posts << post
      end

      Struct::FacebookFeed.new(page_name,posts)
      
    end

  private

    def facebook_client
      @facebook_client ||= FacebookClient.new
    end

  end
end
