
require('aurita/plugin_controller')
Aurita.import_plugin_model :wiki, :container
Aurita.import_plugin_module :todo, 'gui/todo_calculation_entry_table'
Aurita.import_plugin_controller :todo, :todo_asset

module Aurita
module Plugins
module Todo

  class Todo_Calculation_Asset_Controller < Todo_Asset_Controller

    def list_type
      Todo_Calculation_Entry
    end

    def table_widget
      todo_asset    = load_instance()
      return unless Aurita.user.may_view_content?(todo_asset)
      sort          = param(:sort, :priority)
      sort_dir      = param(:sort_dir, :asc)

      table         = GUI::Todo_Calculation_Entry_Table.new(todo_asset.entries(:sort => sort, :sort_dir => sort_dir))
      headers       = [:done, :title, :priority, :duration, :deadline, :created, :added_by_user, :cost]
      headers       = headers.map { |k| HTML.th { tl(k) } }

      [ 'percent_done', 'title', 'priority', 'duration_days', 'deadline', 'created', 'user_group_id', 'cost' ].each_with_index { |s,header_idx|
        if sort.to_s == s && sort_dir.to_s == 'asc' then dir = 'desc' 
        else dir = 'asc' 
        end
        headers[header_idx].onclick = link_to(todo_asset, :action => :show_table, 
                                              :elememtn => "todo_asset_table_#{todo_asset.todo_asset_id}", 
                                              :sort     => s, :sort_dir => dir)
        headers[header_idx].add_css_class(:active) if s == sort.to_s
      }
      table.headers = headers
      table
    end
    
    def list
      permission_constraints = (Content.content_id.in( 
        Content_Category.select(:content_id) { |cid| 
          cid.where(Content_Category.category_id.in(Aurita.user.category_ids) )
        }
      ))
      own_entries     = Todo_Calculation_Asset.all_with(permission_constraints & (Todo_Asset.user_group_id == Aurita.user.user_group_id)).entities
      foreign_entries = Todo_Calculation_Asset.all_with(permission_constraints & (Todo_Asset.user_group_id <=> Aurita.user.user_group_id)).sort_by(Todo_Asset.user_group_id, :asc).entities
      render_view(:todo_index, 
                  :list_type => model(), 
                  :own_entries => own_entries, 
                  :foreign_entries => foreign_entries) 
    end

  end
  
end
end
end

