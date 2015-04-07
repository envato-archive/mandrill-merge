require 'spec_helper'

describe 'routes' do
  
  describe '#verify-mandrill' do
    it 'returns json with expected keys' do
      post '/verify-mandrill', {:key => 'test'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash.keys).to include('can_connect', 'message')
    end
  end

  describe '#select-template' do
    it 'succeeds' do
      post '/select-template', {:template => 'anything'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['success']).to be true
    end

    it 'sets the template name in the response message' do
      post '/select-template', {:template => 'the_template'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['message']).to include 'the_template'
    end
  end

end
