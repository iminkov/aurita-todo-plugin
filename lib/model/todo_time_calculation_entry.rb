
require('aurita/model')

module Aurita
module Plugins
module Todo

  class Todo_Time_Calculation_Entry < Todo_Entry

    table :todo_time_calc_entry, :public
    primary_key :todo_time_calc_entry_id, :todo_time_calc_entry_id_seq
    is_a Todo_Entry, :todo_entry_id

    def assigned_users
      User_Group.select { |u|
        u.where(User_Group.user_group_id.in(Todo_Entry_User.select(:user_group_id) { |uid|
          uid.where(Todo_Entry_User.todo_entry_id == todo_entry_id)
        }
        ))
      }
    end

    def cost
      (num_hours().to_f * unit_cost.to_f).to_s
    end

    def total_cost
      c = cost().to_s
      parts = c.split('.')
      parts[1] = '00' if parts[1].length == 0
      parts[1] << '0' if parts[1].length < 2
      "#{parts[0]},#{parts[1]}"
    end
    
    def num_hours
      duration_days.to_i * 8 + duration_hours.to_i
    end

    add_input_filter(:unit_cost) { |c|
      c.strip! 
      c.gsub!(',','.')
      c.to_f.to_s
    }
    add_output_filter(:unit_cost) { |c|
      c.strip! 
      parts = c.split('.')
      parts[1] = '00' if parts[1].length == 0
      parts[1] << '0' if parts[1].length < 2
      "#{parts[0]},#{parts[1]}"
    }

  end 

end # module
end # module
end # module

