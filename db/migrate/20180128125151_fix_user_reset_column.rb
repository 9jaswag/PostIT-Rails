class FixUserResetColumn < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :reset_token, :reset_digest
  end
end
