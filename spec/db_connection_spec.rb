require_relative 'spec_helper'

describe 'views' do
  it "displays the connection list" do
    get "/db"
    expect(last_response.body).to include('Database Connections')
  end

  it "displays the new connection form" do
    get "/db/new"
    expect(last_response.body).to include('<input name="database"')
  end
end
