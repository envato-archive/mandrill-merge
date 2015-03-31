require 'spec_helper'

describe 'our Mandrill' do

  let(:happy_chimp) { double(:valid_api_key? => true, :users_info => {'username' => 'Bubbles'}) } 
  let(:sad_chimp) { double(:valid_api_key? => false) } 

  context 'can connect to Mandrill' do
    before { expect(Mailchimp::Mandrill).to receive(:new).and_return(happy_chimp) }

    it 'should connect using the API key from the environment by default' do
      expect(Mandrill.new.can_connect?).to be true
    end
    
    it 'should retrieve the username' do
      expect(Mandrill.new.username).to eq 'Bubbles'
    end

  end

  context 'cannot connect to Mandrill' do
    before { expect(Mailchimp::Mandrill).to receive(:new).and_return(sad_chimp) }

    it 'should return false' do
      expect(Mandrill.new.can_connect?).to be false
    end

    it 'should not attempt to retrieve the username' do
      expect(sad_chimp).not_to receive(:users_info)
      Mandrill.new.username
    end 
  end

end