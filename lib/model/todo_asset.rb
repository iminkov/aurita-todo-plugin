
require('aurita/model')
Aurita.import_plugin_model :wiki, :asset
Aurita.import_plugin_model :todo, :todo_entry

module Aurita
module Plugins
module Todo

  class Todo_Asset < Aurita::Plugins::Wiki::Asset

    table :todo_asset, :public
    primary_key :todo_asset_id, :todo_asset_id_seq

    is_a Aurita::Plugins::Wiki::Asset, :asset_id

    use_label :name

    is_polymorphic :concrete_model

    expects :name

    @entries = false

    def self.entries_of(todo_asset_id, params={})
      sort     = params[:sort]
      sort_dir = params[:sort_dir].to_sym
      query = Todo_Entry.all_with(Todo_Entry.todo_asset_id == todo_asset_id).sort_by(:done, :asc)
      if sort.to_s == 'duration_days' then
        query.sort_by('duration_days', sort_dir)
        query.sort_by('duration_hours', sort_dir)
      else
        query.sort_by(sort, sort_dir)
      end
      query.sort_by(Todo_Entry.todo_entry_id, :desc)

      return query.entities
    end
    def entries(params={})
      @entries = self.class.entries_of(todo_asset_id, params) unless @entries
      @entries
    end

    def has_entries? 
      entries().length > 0
    end

    def accept_visitor(v)
      v.visit_form_asset(self)
    end

    def user_group
      User_Group.load(:user_group_id => user_group_id)
    end

  end 

  class Todo_Entry < Aurita::Model

    has_a Todo_Asset, :todo_asset_id

  end

end # module
end # module
end # module

