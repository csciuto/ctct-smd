require 'config_helper'
require 'ctct_smd/facebook/facebook_renderer'
require 'ctct_smd/facebook/facebook_feed'

RSpec.describe CTCT_SMD::FacebookRenderer do

   context ".render" do    
    let(:posts) do
      [{
        'story' => "Lowell Downtown Neighborhood Association (LDNA) shared City of Lowell Economic "\
            "Development Office's photo.",
        'message' => "The City of Lowell wants your input on future projects along the Pawtucket Canal "\
            "in the Hamilton Canal District.\n Share your vision on Wednesday Nov. 16 between 6:00 - 8:00 pm at the "\
            "UMass Lowell Innovation Hub, 110 Canal, 3rd Floor.",
        "link" => {
          "url" => "https://www.facebook.com/CityOfLowellEDO/photos/"\
              "a.245778652228781.1073741832.242007365939243/828901927249781/?type=3",
          "name" => "City of Lowell Economic Development Office",
          "caption" => nil,
          "description" => "The City of Lowell wants your input on future projects along the Pawtucket Canal "\
            "in the Hamilton Canal District.\n  Share your vision on Wednesday Nov. 16 between 6:00 - 8:00 pm at the "\
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
      }]
    end       

    let(:feed) { Struct::FacebookFeed.new('Dummy Page', posts) }  

    it "truncates long posts" do      
      result = CTCT_SMD::FacebookRenderer.render(feed)
      expect(result).to include "The City of Lowell wants y...(truncated)"
    end

    it 'formats dates' do
      result = CTCT_SMD::FacebookRenderer.render(feed)
      expect(result).to include "Last Updated: 01:55:31 PM at 11/04/16"
    end
  end

end
