
require('aurita/model')

module Aurita
module Plugins
module Todo

  class Todo_Calculation_Entry < Todo_Entry

    table :todo_calculation_entry, :public
    primary_key :todo_calculation_entry_id, :todo_calculation_entry_id_seq
    is_a Todo_Entry, :todo_entry_id

    def assigned_users
      User_Group.select { |u|
        u.where(User_Group.user_group_id.in(Todo_Entry_User.select(:user_group_id) { |uid|
          uid.where(Todo_Entry_User.todo_entry_id == todo_entry_id)
        }
        ))
      }
    end

    add_input_filter(:cost) { |c|
      c = c.to_s
      c.strip! 
      c.gsub!(',','.')
      c.to_f.to_s
    }
    add_output_filter(:cost) { |c|
      c = c.to_s
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

