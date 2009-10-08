
require('aurita/model')
Aurita.import_plugin_model :todo, :todo_asset

module Aurita
module Plugins
module Todo

  class Todo_Basic_Asset < Todo_Asset

    table :todo_basic_asset, :public
    primary_key :todo_basic_asset_id, :todo_basic_asset_id_seq

    is_a Todo_Asset, :todo_asset_id
  end 

end # module
end # module
end # module

