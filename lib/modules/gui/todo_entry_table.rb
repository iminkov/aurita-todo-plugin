
require('aurita')
require('aurita-gui')
Aurita.import_module :gui, :entity_table
Aurita.import_plugin_model :todo, :todo_entry

module Aurita
module Plugins
module Todo
module GUI

  include Aurita::Plugins::Todo
  include Aurita::GUI

  class Todo_Entry_Table < Entity_Table
  include Aurita::GUI

    def initialize(entries, params={})
      params[:column_css_classes] = [ :done, :info, :priority, :duration, :deadline, :date, :user ] unless params[:column_css_classes]
      params[:class] = :todo_entry_table unless params[:class]
      super(entries, params)
      @row_class = Todo_Entry_Table_Row
    end
    
    def rows()
      if @rows.length == 0 then
        row_vector = []
        @entities.each { |e|
          row_vector << Context_Menu_Element.new(@row_class.new(e, :parent => self), :entity => e)
        }
        @rows = row_vector
      end
      @rows
    end
  end

  class Todo_Entry_Table_Row < Entity_Table_Row
  include Aurita::GUI
  include Aurita::GUI::Link_Helpers
  include Aurita::GUI::Datetime_Helpers

    def initialize(entity, params={})
      params[:id] = "todo_entry_#{entity.todo_entry_id}"
      super(entity, params)
      add_css_class(:deact) if (entity.done)
    end

    def cells
      done_box = HTML.input(:type => :checkbox, :checked => ((@entity.done)? true : nil))
      done_box.onclick = link_to_call(@entity, :action => :toggle_done)
      description = HTML.div(:class => [ :description, :darker_bg ]) { @entity.description } if @entity.description.nonempty? 
      info = HTML.div { 
        HTML.div.title { @entity.title } 
      }

      duration = ''
      if @entity.duration_days.to_i > 0 then
        if @entity.duration_days.to_i == 1 then
          duration << "1&nbsp;#{tl(:day)} " 
        else
          duration << "#{@entity.duration_days}&nbsp;#{tl(:days)} " 
        end
      end
      if @entity.duration_hours.to_i > 0 then
        if @entity.duration_hours.to_i == 1 then
          duration << "1&nbsp;#{tl(:hour)}" 
        else
          duration << "#{@entity.duration_hours}&nbsp;#{tl(:hours)}" 
        end
      end

      info[0] << description if description
      done     = HTML.div { done_box + HTML.div(:class => [ :percent_done, :darker_bg ]) {  @entity.percent_done.to_s + '%' } }
      priority = HTML.div { @entity.priority }
      date     = HTML.div { datetime(@entity.created) }
      duration = HTML.div { duration+'&nbsp;' } 
      deadline = HTML.div { date(@entity.deadline)+'&nbsp;' }
      user     = HTML.div { link_to(@entity.user_group) { @entity.user_group.user_group_name } }

      [ done, info, priority, duration, deadline, date, user ]
    end
  end

  class Todo_Container_Entry_Table < Todo_Entry_Table
    def initialize(entities, params={})
      super(entities, params)
      @row_class = Todo_Container_Entry_Table_Row
    end
    def rows()
      if @rows.length == 0 then
        row_vector = []
        @entities.each { |e|
          row_vector << Context_Menu_Element.new(@row_class.new(e, :parent => self), :entity => e, :params => { :article_id => e.article_id })
        }
        @rows = row_vector
      end
      @rows
    end
  end

  class Todo_Container_Entry_Table_Row < Todo_Entry_Table_Row
  include Aurita::GUI
  include Aurita::GUI::Link_Helpers
  include Aurita::GUI::Datetime_Helpers

    def cells
      done_box = HTML.input(:type => :checkbox, :checked => ((@entity.done == 't')? true : nil))
      done_box.onclick = "Aurita.call('Todo::Todo_Container_Entry/toggle_done/todo_entry_id=#{@entity.todo_entry_id}&article_id=#{@entity.article_id}');"
      description = HTML.div(:class => [ :description, :darker_bg ]) { @entity.description } if @entity.description.nonempty? 
      info = HTML.div { 
        HTML.div.title { @entity.title } 
      }

      duration = ''
      if @entity.duration_days.to_i > 0 then
        if @entity.duration_days.to_i == 1 then
          duration << "1&nbsp;#{tl(:day)} " 
        else
          duration << "#{@entity.duration_days}&nbsp;#{tl(:days)} " 
        end
      end
      if @entity.duration_hours.to_i > 0 then
        if @entity.duration_hours.to_i == 1 then
          duration << "1&nbsp;#{tl(:hour)}" 
        else
          duration << "#{@entity.duration_hours}&nbsp;#{tl(:hours)}" 
        end
      end

      info[0] << description if description
      done     = HTML.div { done_box + HTML.div(:class => [ :percent_done, :darker_bg ]) {  @entity.percent_done.to_s + '%' } }
      priority = HTML.div { @entity.priority }
      date     = HTML.div { datetime(@entity.created) }
      duration = HTML.div { duration+'&nbsp;' } 
      deadline = HTML.div { date(@entity.deadline)+'&nbsp;' }
      user     = HTML.div { link_to(@entity.user_group) { @entity.user_group.user_group_name } }

      [ done, info, priority, duration, deadline, date, user ]
    end
  end

end
end
end
end

