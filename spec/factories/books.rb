FactoryBot.define do
    factory :book do
      user_id {'1'}
      title {'タイトル'}
      body {'本文'}
      user
    end
  end