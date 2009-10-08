
require('aurita/model')

module Aurita
module Plugins
module Todo

  class Todo_Container_Entry < Todo_Entry

    table :todo_container_entry, :public
    primary_key :todo_container_entry_id, :todo_container_entry_id_seq
    is_a Todo_Entry, :todo_entry_id

  end 

end # module
end # module
end # module

