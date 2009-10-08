
require('aurita/plugin_controller')

Aurita.import_plugin_module :todo, 'gui/custom_form_elements'

module Aurita
module Plugins
module Todo

  class Todo_Entry_Controller < Plugin_Controller

    def form_groups
      [
        Todo_Entry.todo_asset_id, 
        Todo_Entry.title, 
        Todo_Entry.description, 
        Todo_Entry.priority, 
        Todo_Entry.percent_done, 
        :duration, 
        Todo_Entry.deadline
      ]
    end

    def latest_profile_box(params)
      return unless Aurita.user.is_registered?
      amount = param(:amount)
      amount = 10 unless amount

      entries = Todo_Entry.latest_for_user(:amount => amount)
      return unless entries.first
      box = Box.new(:class => :topic)
      box.header = tl(:upcoming_todos)
      box.body = view_string(:list_upcoming_compact, :entries => entries, :amount => amount)
      box
    end

    def latest_box
      return unless Aurita.user.is_registered?
      amount = param(:amount)
      amount = 5 unless amount

      entries = Todo_Entry.latest_for_user(:amount => amount)
      return unless entries.first

      box = Box.new(:class => :topic_inline, :id => :latest_todo_entries_box)
      box.header = tl(:upcoming_todos)
      box.body = view_string(:list_upcoming, :entries => entries, :amount => amount)
      box
    end

    def show
      todo_asset_id = load_instance().todo_asset_id
      render_controller(Todo_Asset_Controller, :show, :todo_asset_id => todo_asset_id)
    end
    
    def add
      form = model_form(:model => Todo_Entry, :action => :perform_add)
      form[Todo_Entry.todo_asset_id].hidden = true
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, :options => [0,10,20,30,40,50,60,70,80,90,100], :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), :label => tl(:est_duration)))
      form.values = { Todo_Entry.done.to_s => false, 
                      Todo_Entry.todo_asset_id.to_s => param(:todo_asset_id) }
      render_form(form)
    end
    
    def update
      instance = load_instance()
      form     = instance_form(:model => Todo_Entry, :action => :perform_update)
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, :options => [0,10,20,30,40,50,60,70,80,90,100], :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), 
                                               :value => [ instance.duration_days, instance.duration_hours ], 
                                               :label => tl(:est_duration)))
      form[Todo_Entry.todo_asset_id].value  = instance.todo_asset_id
      form[Todo_Entry.todo_asset_id].hidden = true
      
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      render_form(form)
    end
    
    def delete
      form = delete_form()
      form.fields = [ Todo_Entry.title, Todo_Entry.priority ]
      render_form(form)
    end
    
    def perform_add
      @params[:user_group_id] = Aurita.user.user_group_id

      entry = super()
      if param(:percent_done).to_i == 100 then
        entry.done = true
        entry.commit
      end
      after_change()
      return entry
    end

    def perform_update
      entry = load_instance()
      super()
      if param(:percent_done).to_i == 100 then
        entry.done = true
        entry.commit
      elsif param(:percent_done).to_i == 0 then
        entry.done = false
        entry.commit
      end
      after_change()
    end

    def after_change
      todo_asset_id   = param(:todo_asset_id)
      todo_asset_id ||= load_instance().todo_asset_id
      redirect_to(:controller => 'Todo::Todo_Asset', 
                  :action => :show, 
                  :todo_asset_id => todo_asset_id)
    end

    def perform_delete
      exec_js("Element.hide('todo_entry_#{load_instance().todo_entry_id}');")
      after_change()
      super()
    end

    def toggle_done
      entry = load_instance()
      if !entry.done then
        entry.done = true
        entry.percent_done = 100
      else
        entry.done = false
        entry.percent_done = 0 
      end
      entry.commit
      after_change()
    end

  end
  
end
end
end

