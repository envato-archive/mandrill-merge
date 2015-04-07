require 'spec_helper'

describe Database::ConfigStore do
  subject(:config_store) { described_class.new() }

  let(:session) { Rack::MockSession.new(app) }
  let(:config_params) { {
    'host' => '127.0.0.1',
    'port' => 3306,
    'username' => 'root',
    'password' => 'sekrit',
    'database' => 'testdb',
  } }

  describe 'instance methods' do
    before { config_store.save(config_params) }

    it "should be a #{described_class} instance" do
      expect(config_store.class).to eq(described_class) 
    end

    describe '#save' do
      it 'puts something in the store' do
        expect(config_store.send(:store).length).to eq 1
      end
    end
  end

  describe 'class methods' do
    subject(:config_store) { described_class }

    describe '.default' do
      it 'gets default config' do
        expect(config_store.default).to_not be_nil
        expect(config_store.default[:name]).to eq 'default'
      end
    end
  end
end

