describe 'Book機能', type: :system do
    describe 'Book投稿機能' do
        before do
            user_a = FactoryBot.create(:user, user_name:'ユーザーA', email: 'a@example.com') #ユーザーAを作成しておく
            FactoryBot.create(:book, title: '最初のタイトル', body: '最初の本文' ,user: user_a) #作成者がユーザーAであるBookを作成しておく
        end
        context 'ユーザーAがログインしているとき' do
            before do
                visit user_session_path #ユーザーAでログインする
                fill_in 'メールアドレス', with: 'a@example.com'
                fill_in 'パスワード', with: 'password'
                click_button 'ログイン'
            end

            it 'ユーザーAが作成した作品が表示される'　do

            end
        end
    end
end