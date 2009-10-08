
require('aurita/plugin_controller')
Aurita.import_module :context_menu_helpers


module Aurita
module Plugins
module Todo

  class Context_Menu_Controller < Aurita::Plugin_Controller
  include Aurita::Context_Menu_Helpers

    def todo_entry
      todo_entry_id = param(:todo_entry_id)
      todo_entry = Todo_Entry.load(:todo_entry_id => todo_entry_id) 
      todo_asset = Todo_Asset.load(:todo_asset_id => todo_entry.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      todo_entry_id = param(:todo_entry_id)
      article_id = param(:article_id).to_s
      header(tl(:todo_entry))
      entry(:edit, 'Todo::Todo_Entry/update/todo_entry_id='+todo_entry_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Entry/delete/todo_entry_id='+todo_entry_id+'&article_id='+article_id)
    end
   
    def todo_calculation_entry
      todo_calculation_entry_id = param(:todo_calculation_entry_id)
      todo_entry = Todo_Calculation_Entry.load(:todo_calculation_entry_id => todo_calculation_entry_id) 
      todo_asset = Todo_Asset.load(:todo_asset_id => todo_entry.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_entry))
      entry(:edit, 'Todo::Todo_Calculation_Entry/update/todo_calculation_entry_id='+todo_calculation_entry_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Calculation_Entry/delete/todo_calculation_entry_id='+todo_calculation_entry_id+'&article_id='+article_id)
    end

    def todo_time_calculation_entry
      todo_calculation_entry_id = param(:todo_time_calc_entry_id)
      todo_entry = Todo_Time_Calculation_Entry.load(:todo_time_calc_entry_id => todo_calculation_entry_id)
      todo_asset = Todo_Asset.load(:todo_asset_id => todo_entry.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_entry))
      entry(:edit, 'Todo::Todo_Time_Calculation_Entry/update/todo_time_calc_entry_id='+todo_calculation_entry_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Time_Calculation_Entry/delete/todo_time_calc_entry_id='+todo_calculation_entry_id+'&article_id='+article_id)
    end
   
    def todo_container_entry
      todo_container_entry_id = param(:todo_container_entry_id)
      todo_entry = Todo_Container_Entry.load(:todo_time_calc_entry_id => todo_container_entry_id)
      todo_asset = Todo_Asset.load(:todo_asset_id => todo_entry.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_entry))
      entry(:edit, 'Todo::Todo_Container_Entry/update/todo_container_entry_id='+todo_container_entry_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Container_Entry/delete/todo_container_entry_id='+todo_container_entry_id+'&article_id='+article_id)
    end

    def todo_asset
      todo_asset_id = param(:todo_asset_id)
      todo_asset    = Todo_Asset.load(:todo_asset_id => todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_list))
      entry(:edit, 'Todo::Todo_Asset/update/todo_asset_id='+todo_asset_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Asset/delete/todo_asset_id='+todo_asset_id+'&article_id='+article_id)
      if param(:content_id_parent) then
        Wiki::Context_Menu_Controller.container
      end 
    end

    def todo_basic_asset
      todo_basic_asset_id = param(:todo_basic_asset_id)
      todo_basic_asset    = Todo_Basic_Asset.load(:todo_basic_asset_id => todo_basic_asset_id)
      todo_asset          = Todo_Asset.load(:todo_asset_id => todo_basic_asset.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_list))
      entry(:edit, 'Todo::Todo_Basic_Asset/update/todo_basic_asset_id='+todo_basic_asset_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Basic_Asset/delete/todo_basic_asset_id='+todo_basic_asset_id+'&article_id='+article_id)
      if param(:content_id_parent) then
        Wiki::Context_Menu_Controller.container
      end 
    end

    def todo_calculation_asset
      todo_asset_id          = param(:todo_calculation_asset_id)
      todo_calculation_asset = Todo_Calculation_Asset.load(:todo_calculation_asset_id => todo_asset_id)
      todo_asset             = Todo_Asset.load(:todo_asset_id => todo_calculation_asset.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_calculation))
      entry(:edit, 'Todo::Todo_Calculation_Asset/update/todo_calculation_asset_id='+todo_asset_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Calculation_Asset/delete/todo_calculation_asset_id='+todo_asset_id+'&article_id='+article_id)
    end

    def todo_time_calculation_asset
      todo_asset_id        = param(:todo_time_calc_asset_id)
      todo_time_calc_asset = Todo_Time_Calculation_Asset.load(:todo_time_calc_asset_id => todo_asset_id)
      todo_asset           = Todo_Asset.load(:todo_asset_id => todo_time_calc_asset.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_calculation))
      entry(:edit, 'Todo::Todo_Time_Calculation_Asset/update/todo_time_calc_asset_id='+todo_asset_id+'&article_id='+article_id)
      entry(:delete, 'Todo::Todo_Time_Calculation_Asset/delete/todo_time_calc_asset_id='+todo_asset_id+'&article_id='+article_id)
    end

    def todo_container_asset
      todo_asset_id        = param(:todo_container_asset_id)
      todo_container_asset = Todo_Calculation_Asset.load(:todo_container_asset_id => todo_asset_id)
      todo_asset           = Todo_Asset.load(:todo_asset_id => todo_container_asset.todo_asset_id)
      if !Aurita.user.may_edit_content?(todo_asset) then
        render_view(:message_box, :message => tl(:todo_asset_is_locked).gsub('{1}', link_to(todo_asset.user_group)))
        return
      end
      article_id = param(:article_id).to_s
      header(tl(:todo_list))
      todo_asset = Todo_Container_Asset.load(:todo_container_asset_id => todo_asset_id)
      entry(:edit,   'Todo::Todo_Container_Asset/update/todo_container_asset_id='+todo_asset_id+'&article_id='+article_id)
      render_controller(Wiki::Context_Menu_Controller, :container, @params)
    end

  end

end
end
end

