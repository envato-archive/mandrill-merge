require 'spec_helper'

describe 'the real Mandrill' do

  context 'when a valid API key is provided as an environment variable' do

    subject(:mandrill) { Mandrill.new }

    it 'connects using the API key from the environment by default' do
      expect(mandrill.can_connect?).to be true
    end
    
    it 'retrieves the username' do
      expect(mandrill.username).to eq 'marketplacedev@envato.com'
    end

    it 'sends a single email' do
      response = mandrill.send_single_email('bizzz-refund', 'mary-anne.cosgrove@envato.com', [{name: 'FULLNAMEORUSERNAME', content: 'Mary-Anne'}])
      expect(response[0]['status']).to eq 'sent'
    end

    it 'sends a batch of emails' do
      response = mandrill.send_email_batch('bizzz-refund', 
        ['mary-anne.cosgrove@envato.com', 'steven.douglas@envato.com'], 
        [[{name: 'FULLNAMEORUSERNAME', content: 'Mary-Anne'}], [{name: 'FULLNAMEORUSERNAME', content: 'Steven D'}]])
      expect(response[0]['status']).to eq 'sent'
      expect(response[1]['status']).to eq 'sent'
    end  

    it 'fetches the merge tags within the template' do
      response = mandrill.fetch_merge_tags('bizzz-refund')
      expect(response).to eq (['FULLNAMEORUSERNAME'])
    end

  end

  context 'when an invalid API key is provided' do
    let(:sad_mandrill) { Mandrill.new('invalid key') }

    it 'returns false' do
      expect(sad_mandrill.can_connect?).to be false
    end

    it 'has nil username' do
      expect(sad_mandrill.username).to be nil
    end
  end

end
