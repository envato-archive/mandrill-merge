require 'spec_helper'
require 'mandrill'

describe 'Mandrill' do
  it 'should connect using the API key from the environment by default' do
    expect(Mandrill.new.can_connect?).to be true
  end

  it 'should retrieve the username' do
  	expect(Mandrill.new.username).to eq 'marketplacedev@envato.com'
  end	
end

