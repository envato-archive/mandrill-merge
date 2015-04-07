require 'spec_helper'

describe 'Database' do
  let(:connection) { double('DataObjects::Mysql::Connection') }

  let(:config_params) { {
    'host' => '127.0.0.1',
    'port' => 3306,
    'username' => 'root',
    'password' => 'sekrit',
    'database' => 'testdb',
    'driver' => 'mysql',
  } }
  let(:config_item) { Database::ConfigItem.new(config_params) }

  before do
    expect(Database::ConfigStore).to receive(:default).and_return(config_item)
    expect(DataObjects::Connection).to receive(:new).and_return(connection)
  end

  it 'can connect to Database' do
    Database.connection
  end

end

