
require('aurita/model')
Aurita.import_plugin_model :todo, :todo_asset
Aurita.import_plugin_model :todo, :todo_time_calculation_entry

module Aurita
module Plugins
module Todo

  class Todo_Time_Calculation_Asset < Todo_Asset

    table :todo_time_calc_asset, :public
    primary_key :todo_time_calc_asset_id, :todo_time_calc_asset_id_seq
    is_a Todo_Asset, :todo_asset_id

    def self.entries_of(todo_asset_id, params={})
      sort     = params[:sort]
      sort_dir = params[:sort_dir].to_sym
      query = Todo_Time_Calculation_Entry.all_with(Todo_Entry.todo_asset_id == todo_asset_id).sort_by(:done, :asc)
      if sort.to_s == 'duration_days' then
        query.sort_by('duration_days', sort_dir)
        query.sort_by('duration_hours', sort_dir)
      elsif sort.to_s == 'total_cost' then
        query.sort_by('(unit_cost * (duration_days * 8 + duration_hours))', sort_dir)
      else
        query.sort_by(sort, sort_dir)
      end
      query.sort_by(Todo_Entry.todo_entry_id, :desc)

      return query.entities
    end

  end 

end # module
end # module
end # module

