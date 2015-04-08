require 'spec_helper'

describe 'the real Mandrill' do

  context 'a valid API key is provided as an environment variable' do

    subject(:mandrill) { Mandrill.new }

    it 'should connect using the API key from the environment by default' do
      expect(mandrill.can_connect?).to be true
    end
    
    it 'should retrieve the username' do
      expect(mandrill.username).to eq 'marketplacedev@envato.com'
    end

    it 'should send a single email' do
      response = mandrill.send_single_email('bizzz-refund', 'mary-anne.cosgrove@envato.com', [{name: 'FULLNAMEORUSERNAME', content: 'Mary-Anne'}])
      expect(response[0]['status']).to eq 'sent'
    end

    it 'should fetch the merge tags within the template' do
      response = mandrill.fetch_merge_tags('bizzz-refund')
      expect(response).to eq (['FULLNAMEORUSERNAME'])
    end

  end

  context 'an invalid API key is provided' do
    let(:sad_mandrill) { Mandrill.new('invalid key') }

    it 'should return false' do
      expect(sad_mandrill.can_connect?).to be false
    end

    it 'should have nil username' do
      expect(sad_mandrill.username).to be nil
    end
  end

end
