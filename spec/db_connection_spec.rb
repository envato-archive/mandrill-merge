require_relative 'spec_helper'

describe 'view' do
  it "displays the connection list" do
    get "/db"
    expect(last_response.body).to include('Database Connections')
  end
end
