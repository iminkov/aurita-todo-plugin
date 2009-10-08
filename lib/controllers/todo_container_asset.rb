
require('aurita/plugin_controller')
Aurita.import_plugin_model :wiki, :container
Aurita.import_plugin_module :todo, 'gui/todo_entry_table'
Aurita.import_plugin_controller :todo, :todo_asset

module Aurita
module Plugins
module Todo

  class Todo_Container_Asset_Controller < Todo_Asset_Controller
    
    def container_type(params)
        HTML.a(:onclick => link_to(:action  => :add, 
                                   :element => :context_menu, 
                                   :article_content_id => params[:article_content_id])) { 
          HTML.img(:src => '/aurita/images/icons/form_add.gif') + HTML.span() { tl(:todo_list_container) }
        } 
    end

    def add
      form = add_form()
      form.add(Category_Selection_List_Field.new())
      form.add_hidden(:content_id_parent => param(:article_content_id)) if param(:article_content_id)
      render_form(form)
    end

    def after_change
      article = Wiki::Article.find(1).with(Wiki::Article.content_id == param(:content_id_parent)).entity
      article ||= Article.load(:article_id => param(:article_id)) if param(:article_id)
      article.touch if article
      redirect_to(:controller => 'Wiki::Article', :action => :show, :article_id => article.article_id)
    end

    def table_widget
      todo_asset    = load_instance()
      sort          = param(:sort)
      sort        ||= :priority
      sort_dir      = param(:sort_dir)
      sort_dir    ||= :asc

      entries = []
      entries = todo_asset.entries(:sort => sort, :sort_dir => sort_dir) if Aurita.user.may_view_content?(todo_asset)

      table         = GUI::Todo_Container_Entry_Table.new(entries)
      headers       = [ tl(:done) ] 
      headers      += [ HTML.th { tl(:title) }, HTML.th { tl(:priority) }, HTML.th { tl(:duration) }, HTML.th { tl(:deadline) }, HTML.th { tl(:created) }, HTML.th { tl(:added_by_user) } ]

      header_idx = 1
      [ 'title', 'priority', 'duration_days', 'deadline', 'created', 'user_group_id' ].each { |s|
        if sort.to_s == s && sort_dir.to_s == 'asc' then dir = 'desc' 
        else dir = 'asc' 
        end
        headers[header_idx].onclick = link_to(todo_asset, :action => :show_table, 
                                              :element => "todo_asset_table_#{todo_asset.todo_asset_id}", 
                                              :sort    => s, :sort_dir => dir)
        headers[header_idx].add_css_class(:active) if s == sort.to_s
        header_idx += 1
      }
      table.headers = headers
      table
    end

    def show_table
      puts table_widget.to_s
    end

    def container_string(params={})
      article                 = params[:article]
      todo_asset              = params[:todo_asset]
      @params[:todo_asset_id] = todo_asset.todo_asset_id
      table                   = table_widget
      
      view_string(:todo_container, 
                  :article_id => article.article_id, 
                  :list_type  => Todo_Container_Entry, 
                  :todo_asset => todo_asset, 
                  :container_params => params[:container_params], 
                  :table => table)
    end

    def list
    end

  end
  
end
end
end

