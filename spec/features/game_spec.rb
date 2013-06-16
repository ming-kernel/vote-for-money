require 'spec_helper'

describe 'Play game in a group', js: true do
  it 'should enable three browsers' do

    Capybara.default_wait_time = 6

    in_browser(:one) do 
      signup_and_start('one', 'private')      
    end    

    in_browser(:two) do
      signup_and_start('two', 'private')
      
    end

    in_browser(:three) do
      signup_and_start('three', 'private')

    end

    in_browser(:one) do
      within('#left_opponent form') {
        fill_in 'first', with: 10  
        fill_in 'second', with: 20
        fill_in 'third', with: 30
        click_button 'Submit'
        # sleep 2
        page.driver.browser.switch_to.alert.dismiss        
      }
      
    end

    in_browser(:two) do
      sleep 6
      within('#left_opponent') {
        click_button 'Accept'
        page.driver.browser.switch_to.alert.dismiss
      }

    end

    in_browser(:one) {  
      page.driver.browser.switch_to.alert.dismiss 
    }
          
     
    in_browser(:three) { 
      page.driver.browser.switch_to.alert.dismiss 
    } 

    in_browser(:two) { 
      page.driver.browser.switch_to.alert.dismiss 
    }

  end

end