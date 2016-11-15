require 'config_helper'
require 'ctct_smd/facebook/facebook_service'
require 'ctct_smd/facebook/facebook_feed'

RSpec.describe CTCT_SMD::FacebookService do
  describe "#getPage" do

    let(:page) { File.open('spec/fixtures/page.json') }
    let(:page_posts) { File.open('spec/fixtures/page_posts.json') }
    let(:reactions) { File.open('spec/fixtures/reactions.json') }
    let(:comments) { File.open('spec/fixtures/comments.json') }

    before do
      @page_request = stub_request(:get, "https://graph.facebook.com/v2.8/12345").with(
        query: {
          access_token: 'dummy_facebook_token'
        }
      ).to_return(status: 200, body: page, headers: {})    

      @page_posts_request = stub_request(:get, "https://graph.facebook.com/v2.8/12345/posts").with(
        query: hash_including({
          access_token: 'dummy_facebook_token',
          fields: 'story,message,created_time,updated_time,permalink_url,shares,link,name,caption,description,picture',
          limit: '10'
        })
      ).to_return(status: 200, body: page_posts, headers: {})    

      @reactions_request = stub_request(:get, /.*\/reactions/).with(
        query: {
          access_token: 'dummy_facebook_token',
          summary: 'true',
          fields: 'total_count'
        }
      ).to_return(status: 200, body: reactions, headers: {})   

      @comments_request = stub_request(:get, /.*\/comments/).with(
        query: {
          access_token: 'dummy_facebook_token',
          summary: 'true',
          fields: 'total_count',
          filter: 'stream'
        }
      ).to_return(status: 200, body: comments, headers: {})   
      
    end

    it "calls the Facebook API the appropriate number of times" do
      CTCT_SMD::FacebookService.new.get_page(12345)

      expect(@page_request).to have_been_made.times(1)
      expect(@page_posts_request).to have_been_made.times(1)
      expect(@reactions_request).to have_been_made.times(10)
      expect(@comments_request).to have_been_made.times(10)
    end

    it "returns a properly formatted message" do
      page = CTCT_SMD::FacebookService.new.get_page(12345)
      expect(page.feed_name).to eq 'Lowell Downtown Neighborhood Association (LDNA)'
      expect(page.posts.length).to be 10

      # Reactions and comments are always 8 and 1 because we are using the same comments and reactions file each time.
      expect(page.posts[1]).to eq(
        {
          'story' => "Lowell Downtown Neighborhood Association (LDNA) shared City of Lowell Economic "\
              "Development Office's photo.",
          'message' => "The City of Lowell wants your input on future projects along the Pawtucket Canal "\
              "in the Hamilton Canal District. Share your vision on Wednesday Nov. 16 between 6:00 - 8:00 pm at the "\
              "UMass Lowell Innovation Hub, 110 Canal, 3rd Floor.",
          "link" => {
            "url" => "https://www.facebook.com/CityOfLowellEDO/photos/"\
                "a.245778652228781.1073741832.242007365939243/828901927249781/?type=3",
            "name" => "City of Lowell Economic Development Office",
            "caption" => nil,
            "description" => "The City of Lowell wants your input on future projects along the Pawtucket Canal "\
              "in the Hamilton Canal District.  Share your vision on Wednesday Nov. 16 between 6:00 - 8:00 pm at the "\
              "UMass Lowell Innovation Hub, 110 Canal, 3rd Floor.",
            "picture"=>"https://scontent.xx.fbcdn.net/v/t1.0-0/s130x130/"\
                "14938224_828901927249781_4909905586759671458_n.jpg?oh=353d954e71281052a5b776478896255f&oe=5894CCED"
          },         
          'created_time' => '2016-11-03T20:26:04+0000',
          'updated_time' => '2016-11-04T13:55:31+0000',
          'permalink_url' => 'https://www.facebook.com/LDNA.LowellMA/posts/1208322969240344',
          'shares' =>  0,
          'reactions' => 8,
          'comments' => 1
        }
      )
    
      expect(page.posts[5]).to eq(
        {
          'story' => nil,
          'message' => "Please join the Lowell Heritage Partnership to review and comment "\
              "on the Draft Action Plan of the Waterways Vitality Project on Thursday, October 27 at 6 PM at the "\
              "UMass Lowell Innovation Hub, 3rd Floor. Working groups will be formed to solicit final comments before "\
              "publication of the report, which is due in December. Community participation has been a key ingredient "\
              "as to the success and momentum this initiative has gained. Your input is very important and you are "\
              "encouraged to attend.\n\u200b\nFor additional information and a copy of the working draft of "\
              "the plan, please visit www.lowellheritagepartnership.org/next",
          'created_time' => '2016-10-18T00:00:14+0000',
          'updated_time' => '2016-10-18T14:15:28+0000',
          'permalink_url' => 'https://www.facebook.com/LDNA.LowellMA/posts/1188667094539265:0',
          'link' => {
            'url' => 'https://www.facebook.com/LDNA.LowellMA/photos/'\
                'a.362125437193439.82746.362113247194658/1188667094539265/?type=3',
            'name' => 'Timeline Photos',
            'picture' => 'https://scontent.xx.fbcdn.net/v/t1.0-0/s130x130/'\
                '14680767_1188667094539265_2739984275421112341_n.jpg?oh=89fac5ce479c2297633272b0055428da&oe=588EBF66',                        
            'caption' => nil,
            'description' => nil
          },          
          'shares' =>  11,
          'reactions' => 8,
          'comments' => 1
        }
      )
    end

  end
end
