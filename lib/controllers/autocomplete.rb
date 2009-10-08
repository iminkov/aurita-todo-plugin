
require('aurita')
Aurita.import_module :gui, :autocomplete_result
Aurita.import_plugin_model :todo, :todo_asset

module Aurita
module Plugins
module Todo

  class Autocomplete_Controller < Plugin_Controller

    def find_todos(params={})
      return unless params[:keys]
			return unless Aurita.user.category_ids.length > 0
			tags = params[:keys]
			tag  = "#{tags[-1]}%"

      constraints = 
      todo_result = Autocomplete_Result.new()
      Todo_Asset.find(10).with(Todo_Asset.is_accessible & (Todo_Asset.has_tag(tags) | (Todo_Asset.name.ilike(tag)))).each { |b|
        todo_result.entries << { # :id => "Todo__Todo_Asset__#{b.todo_asset_id}", 
                                 :id       => b.class.to_s.split('::')[2..-1].join('__') + '__' + b.pkey.to_s, 
                                 :title    => b.name, 
                                 :header   => tl(:todo_lists), 
                                 :class    => :autocomplete_todo, 
                                 :informal => b.tags }
      }
      return todo_result
    end

  end

end
end
end

