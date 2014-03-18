class AddUserRefToAuthentication < ActiveRecord::Migration
  def change
    add_reference :authentications, :user, index: true
  end
end
