
require('aurita/model')
Aurita.import_plugin_model :todo, :todo_entry

module Aurita
module Plugins
module Todo

  class Todo_Entry_History < Aurita::Model

    table :todo_entry_history, :public
    primary_key :todo_entry_history_id, :todo_entry_history_id_seq

    has_a Todo_Entry, :todo_entry_id

  end 

end # module
end # module
end # module
