require 'spec_helper'

class NullLogger
  def info(*args)
  end
end

describe 'Database' do
  before { $logger = NullLogger.new }
  let(:connection) { }

  context 'can connect to Database' do
    before { expect(DataObjects::Connection).to receive(:new).and_return(connection) }

    it 'should work' do
      expect(Database.connection).to_not be_nil
    end

  end
end

