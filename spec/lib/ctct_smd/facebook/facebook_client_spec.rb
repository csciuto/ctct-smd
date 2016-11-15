require 'config_helper'
require 'ctct_smd/facebook/facebook_client'

RSpec.describe CTCT_SMD::FacebookClient do

  context "#get_page" do

    let(:response) { File.open('spec/fixtures/page.json') }
    before do
      stub_request(:get, "https://graph.facebook.com/v2.8/362113247194658").with(
        query: {
          access_token: 'dummy_facebook_token'          
        }
      ).to_return(status: 200, body: response, headers: {})
    end

    it "returns the page information" do      
      result = CTCT_SMD::FacebookClient.new.get_page('362113247194658')
      expect(result['name']).to eq 'Lowell Downtown Neighborhood Association (LDNA)'
      expect(result['id']).to eq '362113247194658'
    end
  end

  context "#get_page_posts" do

    let(:response) { File.open('spec/fixtures/page_posts.json') }

    before do
      Timecop.freeze(Time.now)

      stub_request(:get, "https://graph.facebook.com/v2.8/362113247194658/posts").with(
        query: {
          access_token: 'dummy_facebook_token',
          fields: 'story,message,created_time,updated_time,permalink_url,shares,link,name,caption,description,picture',
          limit: '10',
          since: (Time.now - (7*24*60*60) ).to_i
        }
      ).to_return(status: 200, body: response, headers: {})
    end

    it "returns a list of posts" do
      result = CTCT_SMD::FacebookClient.new.get_page_posts('362113247194658')['data']
      expect(result.size).to eq 10
      expect(result[0]['message']).not_to be_nil
    end
  end

  context "#get_page_post_reactions" do

    let(:response) { File.open('spec/fixtures/reactions.json') }

    before do
      stub_request(:get, "https://graph.facebook.com/v2.8/362113247194658_1208322969240344/reactions").with(
        query: {
          access_token: 'dummy_facebook_token',
          summary: 'true',
          fields: 'total_count'
        }
      ).to_return(status: 200, body: response, headers: {})
    end

    it "returns a summary of comments" do
      result = CTCT_SMD::FacebookClient.new.get_page_post_reactions('362113247194658_1208322969240344')['summary']
      expect(result.size).to eq 1
      expect(result['total_count']).to eq 8
    end
  end

  context "#get_page_post_comments" do

    let(:response) { File.open('spec/fixtures/comments.json') }

    before do
      stub_request(:get, "https://graph.facebook.com/v2.8/362113247194658_1208322969240344/comments").with(
        query: {
          access_token: 'dummy_facebook_token',
          summary: 'true',
          fields: 'total_count',
          filter: 'stream'
        }
      ).to_return(status: 200, body: response, headers: {})
    end

    it "returns a summary of comments" do
      result = CTCT_SMD::FacebookClient.new.get_page_post_comments('362113247194658_1208322969240344')['summary']
      expect(result.size).to eq 1
      expect(result['total_count']).to eq 1
    end
  end
end
