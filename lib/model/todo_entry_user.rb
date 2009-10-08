
require('aurita/model')

module Aurita
module Plugins
module Todo

  class Todo_Entry_User < Aurita::Model

    table :todo_entry_user, :public
    primary_key :todo_entry_user_id, :todo_entry_user_id_seq

    def user_group
      User_Group.load(:user_group_id => user_group_id)
    end

  end 

end # module
end # module
end # module

