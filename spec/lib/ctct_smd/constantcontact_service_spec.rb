require 'config_helper'
require 'ctct_smd/constantcontact_service'
require 'ctct_smd/constantcontact_client'

RSpec.describe CTCT_SMD::ConstantContactService do

  context "#send_email" do

    let(:feeds) do
      [
        Struct.new(:name,:posts).new(
          'Lowell Downtown Neighborhood Association (LDNA)',
          [
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
          ]
        )
      ]
    end

    it "successfully processes an ERB" do
      client = instance_double("CTCT_SMD::ConstantContactClient")
      expect(client).to receive(:create_campaign)

      client_klass = class_double("CTCT_SMD::ConstantContactClient").as_stubbed_const(
        :transfer_nested_constants => true)
      expect(client_klass).to receive(:new).and_return(client)

      foo = CTCT_SMD::ConstantContactService.new.send_email(feeds)
      puts foo
    end

  end

end
