
require('aurita')
Lore::Context.enter :aurita

Aurita.import_plugin_model :todo, :todo_asset

include Aurita::Main
include Aurita::Plugins::Todo

 t = Todo_Asset.create(:user_group_id => 101, 
                       :tags => 'foo bar batz', 
                       :name => 'Test 1')

 puts t.name
