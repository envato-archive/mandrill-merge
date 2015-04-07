require_relative 'spec_helper'

describe 'views' do
  it "returns the connection list", pending:true do
    get "/db/test"
    expect(last_response.body).to include('Database Connections')
  end
end
