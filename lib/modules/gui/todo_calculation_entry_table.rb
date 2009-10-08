
require('aurita')
require('aurita-gui')
Aurita.import_module :gui, :entity_table
Aurita.import_module :gui, :i18n_helpers
Aurita.import_module :gui, :format_helpers
Aurita.import_plugin_model :todo, :todo_calculation_entry
Aurita.import_plugin_module :todo, 'gui/todo_entry_table'

module Aurita
module Plugins
module Todo
module GUI

  include Aurita::Plugins::Todo
  include Aurita::GUI

  class Todo_Calculation_Entry_Table < Todo_Entry_Table
  include Aurita::GUI
  include Aurita::GUI::Format_Helpers
  include Aurita::GUI::I18N_Helpers

    attr_accessor :cost_total, :cost_total_done

    def initialize(entries, params={})
      params[:column_css_classes] = [ :done, :info, :priority, :duration, :deadline, :date, :user, :cost ] unless params[:column_css_classes]
      super(entries, params)
      @row_class       = Todo_Calculation_Entry_Table_Row
      @cost_total      = 0.0
      @cost_total_done = 0.0
      entries.each { |e|
        @cost_total      += e.cost.to_s.gsub(',','.').to_f
        @cost_total_done += e.cost.to_s.gsub(',','.').to_f if e.done == 't'
      }
    end

    def string
      totals = HTML.div.totals_done { HTML.div.value { "#{decimal(@cost_total_done)}" } + HTML.div.label { "#{tl(:total_costs_done)}" } } + 
               HTML.div.totals      { HTML.div.value { "#{decimal(@cost_total)}" } + HTML.div.label { "#{tl(:total_costs)}" } }
      super + HTML.div.calculation_totals { totals } 
    end
    alias to_s string
  end

  class Todo_Calculation_Entry_Table_Row < Todo_Entry_Table_Row
  include Aurita::GUI
  include Aurita::GUI::Link_Helpers
  include Aurita::GUI::Datetime_Helpers

    def cells

      assigned_users = []
      @entity.assigned_users.each { |u|
        assigned_users << HTML.span { link_to(u) { u.user_group_name } } + ' ' 
      }

      c         = super() # [ done, info, priority, duration, deadline, date, user ]
      done_box  = HTML.input(:type => :checkbox, :checked => ((@entity.done == 't')? true : nil))
      done_box.onclick = "Aurita.call({ action: 'Todo::Todo_Calculation_Entry/toggle_done/todo_entry_id=#{@entity.todo_entry_id}' });"
      done      = HTML.div { done_box + HTML.div(:class => [ :percent_done, :darker_bg ]) {  @entity.percent_done.to_s + '%' } }
      assignees = HTML.div(:class => [ :assignees, :darker_bg ]) { assigned_users }
      c[0]      = done
      c[1]      += assignees
      cost      = HTML.div.cost { @entity.cost }
      c + [ cost ]
    end
  end

end
end
end
end

