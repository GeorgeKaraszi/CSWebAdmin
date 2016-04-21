json.array!(@ldap_users) do |ldap_user|
  json.extract! ldap_user, :id
  json.url ldap_user_url(ldap_user, format: :json)
end
