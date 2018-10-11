module UserSpecHelpers
  def sign_in(user)
    post login_url, params: { session: { username_signin: user.username, password_signin: user.password } }
  end

  def add_to_group(group, user)
    post groups_add_member_path(group_id: group.id, user_id: user.id), xhr: true
  end

  def remove_from_group(group, user)
    delete groups_remove_member_path(group_id: group.id, user_id: user.id), xhr: true
  end
end
