
require('aurita/plugin_controller')
Aurita.import_plugin_model :wiki, :container
Aurita.import_plugin_module :todo, 'gui/todo_entry_table'

module Aurita
module Plugins
module Todo

  class Todo_Asset_Controller < Plugin_Controller
    
    def form_groups
      [
        Todo_Asset.name, 
        Todo_Asset.comment, 
        Category.category_id, 
        Todo_Asset.locked, 
        Content.tags, 
        :content_id_parent
      ]
    end

    def toolbar_buttons
      return unless Aurita.user.is_registered? 

      HTML.a(:class => :icon, 
             :onclick => link_to(:controller => 'Todo::Todo_Asset', :action => :list) ) { 
        HTML.img(:src => '/aurita/images/icons/todo_list.gif') + 
        tl(:show_todo_lists) 
      }
    end

    def find(params)
      key = params[:key]
      
      todos = Array.new
      Aurita.user.categories.each { |cat| 
        todos += find_in_category(cat, key)
      }
      box = Box.new(:type => :none, :class => :topic_inline)
      box.body = view_string(:todo_asset_list, :todo_assets => todos)
      box.header = tl(:todos)
      return box if todos.length > 0
    end

    def find_full(params)
      find(params)
    end

    def find_in_category(category, key)
      constraints = Lore::Clause.new('')
      key.to_s.split(' ').each { |k|
        constraints  = constraints & (Todo_Asset.tags.has_element_ilike(k+'%')) & (Todo_Asset.content_id.in( Content_Category.select(:content_id) { |cc|
          cc.where(Content_Category.category_id == category.category_id)
        } ))
      }
      key.to_s.split(' ').each { |k|
        constraints  = constraints || (Todo_Asset.name.ilike('%' << k+'%')) & (Todo_Asset.content_id.in( Content_Category.select(:content_id) { |cc|
          cc.where(Content_Category.category_id == category.category_id)
        }
      ))
      }
      Todo_Asset.all_with(constraints).entities
    end

    def add
      form = add_form()
      form.add(Category_Selection_List_Field.new())
      form.add_hidden(:content_id_parent => param(:article_content_id)) if param(:article_content_id)
      form[Content.tags] = Tag_Autocomplete_Field.new(:name => Content.tags.to_s, :label => tl(:tags))
      form[Content.tags].required!
      form[Content.locked].value = 'false'
      exec_js('Aurita.Main.init_autocomplete_tags();')
      Page.new(:header => tl(:add_todo)) { decorate_form(form) } 
    end

    def update
      todo_asset = load_instance()
      form = update_form()
      form.add(Category_Selection_List_Field.new(:value => todo_asset.category_ids))
      form.add_hidden(:content_id_parent => param(:article_content_id)) if param(:article_content_id)
      form[Content.tags] = Tag_Autocomplete_Field.new(:name => Content.tags.to_s, :label => tl(:tags), :value => todo_asset.tags)
      form[Content.tags].required!
      exec_js('Aurita.Main.init_autocomplete_tags();')
      decorate_form(form) 
    end

    def perform_add
      @params[:user_group_id] = Aurita.user.user_group_id
      todo_asset = super()
      Content_Category.create_for(todo_asset, param(:category_ids))

      if(param(:content_id_parent)) then
        text_asset = Wiki::Text_Asset.create(:text => '', 
                                             :tags => 'todo')
        # Hook Todo_Asset to Text_Asset: 
        Wiki::Container.create(:content_id_parent => text_asset.content_id, 
                               :content_type => 'TODO', 
                               :content_id_child => todo_asset.content_id)
        # Hook Text_Asset to Article: 
        Wiki::Container.create(:content_id_parent => param(:content_id_parent), 
                               :content_type => 'content', 
                               :content_id_child => text_asset.content_id)
        article = Wiki::Article.find(1).with(Wiki::Article.content_id == param(:content_id_parent)).entity
      end
      after_change()
      return todo_asset
    end

    def perform_update
      instance   = load_instance()
      content_id = instance.content_id
      super()
      Content_Category.update_for(instance, param(:category_ids))
      after_change()
    end

    def perform_delete
      todo_asset = Todo_Asset.load(:todo_asset_id => param(:todo_asset_id))
      Wiki::Container.delete { |c|
        c.where(Wiki::Container.content_id_child == todo_asset.content_id) 
      } 
      super()
      redirect_to(:list)
    end

    def after_change
      if(param(:content_id_parent)) then
        article = Wiki::Article.find(1).with(Wiki::Article.content_id == param(:content_id_parent)).entity
        article ||= Article.load(:article_id => param(:article_id)) if param(:article_id)
        article.touch if article
        redirect_to(:controller => 'Wiki::Article', :action => :show, :article_id => article.article_id)
      else
        redirect_to(load_instance)
      end
    end

    def list_type
      Todo_Entry
    end

    def show
      todo_asset = load_instance()

      page_content_id = "todo_asset_form_#{todo_asset.todo_asset_id}"

      edit_button = HTML.a(:onclick => link_to(todo_asset, :action => :update, :element => page_content_id)) {
        icon_tag(:edit_button) 
      }

      Page.new(:header => todo_asset.name, :tools => edit_button) { 
        HTML.div(:id => page_content_id) { 
          GUI::Button.new(:onclick => link_to(:controller => list_type.model_name, 
                                              :action => :add, 
                                              :element => page_content_id, 
                                              :todo_asset_id => todo_asset.todo_asset_id), 
                          :class   => :submit, 
                          :style   => 'margin-bottom: 10px;') { tl(:add_entry) } + 
          HTML.div(:id => "todo_asset_table_#{todo_asset.todo_asset_id}") { 
            table_widget()
          }
        }
      }
    end

    def table_widget
      todo_asset    = load_instance()
      return unless Aurita.user.may_view_content?(todo_asset)
      sort          = param(:sort, :priority)
      sort_dir      = param(:sort_dir, :asc)

      table         = GUI::Todo_Entry_Table.new(todo_asset.entries(:sort => sort, :sort_dir => sort_dir))
      headers       = [:done, :title, :priority, :duration, :deadline, :created, :added_by_user]
      headers       = headers.map { |k| HTML.th { tl(k) } }

      [ 'percent_done', 'title', 'priority', 'duration_days', 'deadline', 'created', 'user_group_id' ].each_with_index { |s,header_idx|
        if sort.to_s == s && sort_dir.to_s == 'asc' then dir = 'desc' 
        else dir = 'asc' 
        end
        headers[header_idx].onclick = link_to(todo_asset, 
                                              :action   => :show_table, 
                                              :element  => "todo_asset_table_#{todo_asset.todo_asset_id}", 
                                              :sort     => s, 
                                              :sort_dir => dir)
        headers[header_idx].add_css_class(:active) if s == sort.to_s
        header_idx += 1
      }
      table.headers = headers
      table
    end

    def show_table
      puts table_widget.to_s
    end
   
    def list
      permission_constraints = (Content.content_id.in( 
        Content_Category.select(:content_id) { |cid| 
          cid.where(Content_Category.category_id.in(Aurita.user.category_ids) )
        }
      ))
      own_entries     = Todo_Asset.all_with(permission_constraints & 
                                            (Todo_Asset.user_group_id == Aurita.user.user_group_id)).sort_by(Todo_Asset.created, :desc)
      own_entries     = own_entries.polymorphic.entities
      foreign_entries = Todo_Asset.all_with(permission_constraints & 
                                            (Todo_Asset.user_group_id <=> Aurita.user.user_group_id)).sort_by(Todo_Asset.user_group_id, :asc)
      foreign_entries = foreign_entries.polymorphic.entities

      HTML.div { 
        Page.new(:header => tl(:my_todos)) { 
          HTML.div(:id => :todo_asset_form) { 
            GUI::Button.new(:onclick => link_to(:controller => 'Todo::Todo_Basic_Asset', :action => :add), 
                            :icon => 'add', :class => 'submit' ) { tl(:add_todo_list) } + 
            GUI::Button.new(:onclick => link_to(:controller => 'Todo::Todo_Calculation_Asset', :action => :add), 
                            :icon => 'add', :class => 'submit' ) { tl(:add_calculation) } + 
            GUI::Button.new(:onclick => link_to(:controller => 'Todo::Todo_Time_Calculation_Asset', :action => :add), 
                            :icon => 'add', :class => 'submit' ) { tl(:add_time_calculation) } 
          } + 
          HTML.div.topic_inline { 
            own_entries.map { |e|
              entry = HTML.div.index_entry { 
                        HTML.div.header { link_to(e) { e.name } } + 
                        HTML.div.info { e.comment } + 
                        HTML.div.info { "#{tl(:categories)}: #{e.categories.map { |c| link_to(c) { c.category_name }}.join(', ')}" }
              }
              Context_Menu_Element.new(entry, :entity => e)
            }
          }
        } + 
        Page.new(:header => tl(:todo_lists_of_other_users)) { 
          HTML.div.topic_inline { 
            foreign_entries.map { |e|
              entry = HTML.div.index_entry { 
                        HTML.div.header { link_to(e) { e.name } } + 
#                       HTML.div.info { "#{tl(:user)}: #{link_to(e.user_group) { e.user_group.user_group_name } }"} + 
                        HTML.div.info { e.comment } + 
                        HTML.div.info { "#{tl(:categories)}: #{e.categories.map { |c| link_to(c) { c.category_name }}.join(', ')}" }
              }
              Context_Menu_Element.new(entry, :entity => e)
            }
          }
        }
      }
    end

  end
  
end
end
end

