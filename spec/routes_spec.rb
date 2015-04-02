require 'spec_helper'

describe 'routes' do
  
  describe '#submit-api' do
    it 'should redirect to verify connection' do
      post "/submit-api", {:key => 'test'}
      last_response.should be_redirect
      follow_redirect!
      last_request.url.should match /verify-mandrill$/
    end
  end

end
