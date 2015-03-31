require 'spec_helper'

describe 'the real Mandrill' do

  context 'a valid API key is provided as an environment variable' do

    it 'should connect using the API key from the environment by default' do
      expect(Mandrill.new.can_connect?).to be true
    end
    
    it 'should retrieve the username' do
      expect(Mandrill.new.username).to eq 'marketplacedev@envato.com'
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

