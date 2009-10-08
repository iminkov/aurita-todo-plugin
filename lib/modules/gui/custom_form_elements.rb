
require('aurita')

module Aurita
module Plugins
module Todo

  module GUI

    class Priority_Select_Field < Aurita::GUI::Select_Field
    include Aurita::GUI
    include Aurita::GUI::I18N_Helpers

      def initialize(params={}, &block)
        labels = {}
        options = (1..10).to_a
        options.each { |p|
          labels[p.to_s] = p.to_s
        }
        labels['1'] = "1 (#{tl(:highest_priority)})"
        labels['10'] = "10 (#{tl(:lowest_priority)})"
        params[:options] = options unless params[:options]
#        params[:option_labels] = labels
        params[:label]   = tl(:priority) unless params[:label]
        params[:name]    = Todo_Entry.priority unless params[:name]
        super(params, &block)
      end

    end

  end
  
end
end
end

