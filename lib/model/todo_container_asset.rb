
require('aurita/model')
Aurita.import_plugin_model :todo, :todo_asset

module Aurita
module Plugins
module Todo

  class Todo_Container_Asset < Todo_Asset

    table :todo_container_asset, :public
    primary_key :todo_container_asset_id, :todo_container_asset_id_seq

    is_a Todo_Asset, :todo_asset_id

    def self.entries_of(todo_asset_id, params={})
      sort       = params[:sort]
      sort     ||= :priority
      sort_dir   = params[:sort_dir].to_sym if params[:sort_dir]
      sort_dir ||= :asc
      Todo_Container_Entry.all_with(Todo_Entry.todo_asset_id == todo_asset_id).sort_by(:done, :asc).sort_by(sort, sort_dir).sort_by(Todo_Entry.todo_entry_id).entities
    end

  end 

end # module
end # module
end # module

