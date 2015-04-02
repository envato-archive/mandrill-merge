require 'spec_helper'

describe 'routes' do
  
  describe '#verify-mandrill' do
    it 'returns json with expected keys' do
      post '/verify-mandrill', {:key => 'test'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash.keys).to include('can_connect', 'message')
    end
  end

end
