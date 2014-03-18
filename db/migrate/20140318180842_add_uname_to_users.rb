class AddUnameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :uname, :string
  end
end
