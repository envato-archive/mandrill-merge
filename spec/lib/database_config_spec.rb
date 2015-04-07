require 'spec_helper'

describe Database::ConfigStore do
  subject(:config_store) { described_class }

  let(:config_params) { {
    'host' => '127.0.0.1',
    'port' => 3306,
    'username' => 'root',
    'password' => 'sekrit',
    'database' => 'testdb',
  } }


  context 'when it has a db connection stored' do
    before { config_store.save(config_params) }

    describe '.default' do
      it 'gets default config' do
        expect(config_store.default).to_not be_nil
        expect(config_store.default['name']).to eq 'default'
      end
    end
  end
end

