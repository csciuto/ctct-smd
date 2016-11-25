require 'erb'
require 'ctct_smd/rendering'

module CTCT_SMD
  class FacebookRenderer
    extend CTCT_SMD::Rendering
      # Generates a Div that represents the Facebook feed
      def self.render(feed)
        template = ERB.new(File.read(CTCT_SMD.config[:facebook_template]))
        template.result(binding)
      end
  end
end
