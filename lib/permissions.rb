
require('aurita/plugin')

module Aurita
module Plugins
module Todo


  # Usage: 
  #
  #  plugin_get(Hook.right_column)
  #
  class Permissions < Aurita::Plugin::Manifest

    register_permission(:create_todo_lists, 
                        :type    => :bool, 
                        :default => true)
    register_permission(:view_todo_lists, 
                        :type    => :bool, 
                        :default => true)

  end

end
end
end

