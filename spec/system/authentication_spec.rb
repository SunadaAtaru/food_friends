# spec/system/authentication_spec.rb
require 'rails_helper'

RSpec.describe 'Authentication', type: :system do
  describe 'user registration' do
    it 'allows new users to register' do
      visit new_user_registration_path
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      expect {
        click_button 'Sign up'
      }.to change(User, :count).by(1)
    end
  end
end