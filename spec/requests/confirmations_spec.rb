# spec/requests/confirmations_spec.rb
describe 'POST /users/confirmation' do
  let(:unconfirmed_user) { create(:user, :unconfirmed) }

  it '確認メールが再送信される' do
    ActionMailer::Base.deliveries.clear

    expect {
      post user_confirmation_path, params: { 
        user: { email: unconfirmed_user.email } 
      }
    }.to change { ActionMailer::Base.deliveries.size }.by(1)

    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to eq('アカウントの確認手順')
  end
end