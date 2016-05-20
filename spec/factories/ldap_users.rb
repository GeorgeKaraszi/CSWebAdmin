FactoryGirl.define do
  factory :ldap_user do
    new  {{
        :gidNumber => '99999',
        :uidNumber => '99999',
        :uid => 'rspecTester',
        :cn => 'rspecTester',
        :userPassword => 'testPassword',
        :givenName => 'Go Old Boy',
        :sn => 'Bad Old Boy',
        :homeDirectory => '/home'
    }}
  end
end
