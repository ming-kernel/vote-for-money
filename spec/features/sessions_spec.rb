require 'spec_helper'
describe 'User Sessions' do
  let!(:user) { User.create!(name: name, password: password, password_confirmation: password, round_id: 0) }
  let(:name) { 'huming' }
  let(:password) { 'private' }  

  # context 'failure' do
  #   before do 
  #     within('form') {
  #       fill_in 'username', with: name
  #       fill_in 'password', with: '3'
  #       click_on 'Login'
  #     }
  #   end

  #   it 'display error message' do
  #     expect(page).to have_content('Inalid')
  #   end
  # end

  context 'success' do
    before do
      login(name, password)        
    end

    it 'display welcome message' do
    # save_and_open_page
    expect(page).to have_content('Welcome')
    end

  end
end
  
