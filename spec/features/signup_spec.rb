require 'spec_helper'

describe  'User signup' do  

  context 'success' do
    before do
      signup('huming', 'go')   
    end
    
    it 'should welcome user' do
      # save_and_open_page
      expect(page).to have_content('Welcome')
      # sleep(10)
    end  

  end

end