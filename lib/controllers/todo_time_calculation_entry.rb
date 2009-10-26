
require('aurita/plugin_controller')

Aurita.import_plugin_module :todo, 'gui/custom_form_elements'
Aurita.import_plugin_controller :todo, :todo_entry
Aurita.import_plugin_model :todo, :todo_entry_user

module Aurita
module Plugins
module Todo

  class Todo_Time_Calculation_Entry_Controller < Todo_Entry_Controller

    def form_groups
      [
        Todo_Entry.todo_asset_id, 
        Todo_Entry.title, 
        Todo_Entry.description, 
        Todo_Entry.priority, 
        Todo_Entry.percent_done, 
        :assigned_users, 
        Todo_Time_Calculation_Entry.unit_cost, 
        :duration, 
        Todo_Entry.deadline
      ]
    end

    def add
      form = add_form()
      form[Todo_Entry.todo_asset_id].hidden = true
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, 
                                             :options => [0,10,20,30,40,50,60,70,80,90,100], 
                                             :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), 
                                               :label => tl(:est_duration)))
      user_autocomplete = Aurita::GUI::User_Selection_List_Field.new(:name => :user_group_ids, :label => tl(:assigned_users))
      form[:assigned_users] = user_autocomplete
      form.values = { Todo_Entry.done.to_s => 'f', 
                      Todo_Entry.todo_asset_id.to_s => param(:todo_asset_id) }
      render_form(form)
      exec_js("Aurita.Main.init_autocomplete_single_username(); ")
    end
    
    def update
      instance = load_instance()
      form     = instance_form(:model => Todo_Time_Calculation_Entry, :action => :perform_update)
      form.add(Aurita::GUI::Select_Field.new(:name => Todo_Entry.percent_done, :options => [0,10,20,30,40,50,60,70,80,90,100], :label => tl(:percent_done)))
      form.add(Aurita::GUI::Duration_Field.new(:name => :duration, :day_range => (0..5), :hour_range => (0..8), 
                                               :value => [ instance.duration_days, instance.duration_hours ], 
                                               :label => tl(:est_duration)))
      assigned_users = {}
      instance.assigned_users.each { |u| 
        assigned_users[u.user_group_id] = u.user_group_name
      } 
      user_autocomplete = Aurita::GUI::User_Selection_List_Field.new(:name => :user_group_ids, :label => tl(:assigned_users))
      user_autocomplete.options = assigned_users
      user_autocomplete.value = assigned_users.keys
      form[:assigned_users] = user_autocomplete
      form[Todo_Entry.todo_asset_id].value = instance.todo_asset_id
      form[Todo_Entry.todo_asset_id].hidden = true
      
      form.add(Aurita::Plugins::Todo::GUI::Priority_Select_Field.new())
      render_form(form)
      exec_js("Aurita.Main.init_autocomplete_single_username(); ")
    end

    def perform_add
      instance = super()
      param(:user_group_ids, []).each { |uid|
        Todo_Entry_User.create(:user_group_id => uid, :todo_entry_id => instance.todo_entry_id)
      }
    end

    def perform_update
      super()
      instance = load_instance()
      Todo_Entry_User.delete { |tu|
        tu.where(Todo_Entry_User.todo_entry_id == instance.todo_entry_id)
      }
      param(:user_group_ids, []).each { |uid|
        Todo_Entry_User.create(:user_group_id => uid, 
                               :todo_entry_id => instance.todo_entry_id)
      }
    end

    def after_change
      todo_asset_id   = param(:todo_asset_id)
      todo_asset_id ||= load_instance().todo_asset_id
      redirect_to(:controller => 'Todo::Todo_Time_Calculation_Asset', 
                  :action => :show, 
                  :todo_asset_id => todo_asset_id)
    end

  end
  
end
end
end

