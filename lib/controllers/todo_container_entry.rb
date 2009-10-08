
require('aurita/plugin_controller')

Aurita.import_plugin_module :todo, 'gui/custom_form_elements'
Aurita.import_plugin_controller :todo, :todo_entry
Aurita.import_plugin_model :todo, :todo_entry_user

module Aurita
module Plugins
module Todo

  class Todo_Container_Entry_Controller < Todo_Entry_Controller

    def form_groups
      [
        Todo_Entry.todo_asset_id, 
        Wiki::Article.article_id, 
        Todo_Entry.title, 
        Todo_Entry.description, 
        Todo_Entry.priority, 
        Todo_Entry.percent_done, 
        :duration, 
        Todo_Entry.deadline
      ]
    end

    def add
      form = model_form(:model => Todo_Container_Entry, :action => :perform_add)
      form[Todo_Entry.todo_asset_id].hidden = true
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, :options => [0,10,20,30,40,50,60,70,80,90,100], :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), :label => tl(:est_duration)))
      form.add(Hidden_Field.new(:name => Wiki::Article.article_id.to_s, :value => param(:article_id)))
      form.values = { Todo_Entry.done.to_s => 'f', 
                      Wiki::Article.article_id => param(:article_id),
                      Todo_Entry.todo_asset_id.to_s => param(:todo_asset_id) }
      render_form(form)
    end

    def update
      instance = load_instance()
      form     = instance_form(:model => Todo_Container_Entry, :action => :perform_update)
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, :options => [0,10,20,30,40,50,60,70,80,90,100], :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), 
                                               :value => [ instance.duration_days, instance.duration_hours ], 
                                               :label => tl(:est_duration)))
      form[Todo_Entry.todo_asset_id].value  = instance.todo_asset_id
      form.add(Hidden_Field.new(:name => Wiki::Article.article_id.to_s, :value => param(:article_id)))
      form[Todo_Entry.todo_asset_id].hidden = true
      
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      render_form(form)
    end
    
    def delete
      form = delete_form()
      form.fields = [ Todo_Entry.title, Todo_Entry.priority, Wiki::Article.article_id ]
      form.add(Hidden_Field.new(:name => Wiki::Article.article_id.to_s, :value => param(:article_id)))
      render_form(form)
    end

    def after_change
      article = Wiki::Article.load(:article_id => param(:article_id)) if param(:article_id)
      article.touch if article
      redirect_to(:controller => 'Wiki::Article', 
                  :action => :show, 
                  :article_id => param(:article_id))
    end
    
  end
  
end
end
end

