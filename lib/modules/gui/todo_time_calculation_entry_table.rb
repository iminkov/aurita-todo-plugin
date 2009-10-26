
require('aurita')
require('aurita-gui')
Aurita.import_module :gui, :entity_table
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :format_helpers
Aurita.import_plugin_model :todo, :todo_calculation_entry
Aurita.import_plugin_module :todo, 'gui/todo_entry_table'
Aurita.import_plugin_module :todo, 'gui/todo_calculation_entry_table'

module Aurita
module Plugins
module Todo
module GUI

  include Aurita::Plugins::Todo
  include Aurita::GUI

  class Todo_Time_Calculation_Entry_Table < Todo_Calculation_Entry_Table
  include Aurita::GUI
  include Aurita::GUI::Format_Helpers
  include Aurita::GUI::I18N_Helpers

    attr_accessor :cost_total, :cost_total_done

    def initialize(entries, params={})
      params[:column_css_classes] = [ :done, :info, :priority, :duration, :deadline, :date, :user, :unit_cost, :total_cost, :assignees ] unless params[:column_css_classes]
      super(entries, params)
      @total_hours = 0
      entries.each { |e|
        @total_hours += e.duration_days.to_i * 8 + e.duration_hours.to_i
      }
      @row_class       = Todo_Time_Calculation_Entry_Table_Row
    end
    def string
      totals = HTML.div.totals_done { HTML.div.value { "#{@total_hours}" } + HTML.div.label { "#{tl(:total_hours)}" } } 
      super + HTML.div.calculation_totals { totals } 
    end
    alias to_s string

  end

  class Todo_Time_Calculation_Entry_Table_Row < Todo_Entry_Table_Row
  include Aurita::GUI
  include Aurita::GUI::Link_Helpers
  include Aurita::GUI::Datetime_Helpers

    def cells

      assigned_users = []
      @entity.assigned_users.each { |u|
        assigned_users << HTML.span { link_to(u) { u.user_group_name } } + ' '
      }

      c          = super() # [ done, info, priority, duration, deadline, date, user ]
      done_box   = HTML.input(:type => :checkbox, :checked => ((@entity.done)? true : nil))
      done_box.onclick = "Aurita.call('Todo::Todo_Time_Calculation_Entry/toggle_done/todo_entry_id=#{@entity.todo_entry_id}');"
      done       = HTML.div { done_box + HTML.div(:class => [ :percent_done, :darker_bg ]) {  @entity.percent_done.to_s + '%' } }
      assignees  = HTML.div(:class => [ :assignees, :darker_bg ]) { assigned_users }
      c[0]       = done
      c[1]      += assignees if assigned_users.length > 0
      unit_cost  = HTML.div.unit_cost { @entity.unit_cost }
      total_cost = HTML.div.total_cost { @entity.total_cost }
      c + [ unit_cost, total_cost ]
    end
  end

end
end
end
end

