require 'spec_helper'

describe 'Play game in a group', js: true do
  it 'should enable three browsers' do

    Capybara.default_wait_time = 6

    # in_browser(:one) do 
    #   signup_and_start('one', 'private')      
    # end    

    using_session(:one) { signup_and_start('one', 'private') }
    using_session(:two) { signup_and_start('two', 'private') }
    using_session(:three) { signup_and_start('three', 'private') }

    # using_session(:one) {
    #   find('#dialog').should have_content('Decision')  
    # }

    using_session(:one) do
      within('#left_opponent form') {
        fill_in 'first', with: '10'  
        fill_in 'second', with: '20'
        fill_in 'third', with: '30'
        click_button 'Submit'
      }
    end

    using_session(:two) do
      within('#left_opponent #opponent') {
        find('#first').should have_content('10')
        find('#second').should have_content('20')
        find('#third').should have_content('30')        
      }
      # within('#left_opponent') {
      #   click_button 'Accept'
      # }
      # page.driver.browser.switch_to.alert.dismiss

    end
  # sleep 5
  
  
  # using_session(:three) { page.driver.browser.switch_to.alert.dismiss }   
  # using_session(:two) { page.driver.browser.switch_to.alert.dismiss }
  # using_session(:one) { page.driver.browser.switch_to.alert.dismiss }
  

  end

end