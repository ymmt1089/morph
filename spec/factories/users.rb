
FactoryBot.define do

    factory :user do
      user_name {'テストユーザー'}
      email {'test1@example.com'}
      encrypted_password {'password'}
      self_introduction {'自己紹介文'}
    end
  end