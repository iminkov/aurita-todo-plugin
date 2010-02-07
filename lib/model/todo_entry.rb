
require('aurita/model')

module Aurita
module Plugins
module Todo

  class Todo_Entry < Aurita::Model

    table :todo_entry, :public
    primary_key :todo_entry_id, :todo_entry_id_seq

    expects :title

    explicit :deadline

    def user_group
      User_Group.load(:user_group_id => user_group_id)
    end

    def category
      Todo_Asset.load(:todo_asset_id => todo_asset_id).category
    end

    add_output_filter(:title) { |t|
      t.to_s.gsub('"','&quot;')
    }

    def self.latest_for_user(params={})
      user     = params[:user]
      amount   = params[:amount]
      amount ||= 5
      user   ||= Aurita.session.user

      select { |te|
        te.where(Todo_Entry.todo_asset_id.in( 
          Todo_Asset.select(Todo_Asset.todo_asset_id) { |tid| 
            tid.where(Todo_Asset.user_group_id == user.user_group_id)
          }) & 
          (te.done == 'f')
        )
        te.limit(amount)
      }
    end

  end 

end # module
end # module
end # module

