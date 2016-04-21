json.array!(@ldap_groups) do |ldap_group|
  json.extract! ldap_group, :id
  json.url ldap_group_url(ldap_group, format: :json)
end
