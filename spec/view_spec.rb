require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'views' do
  describe 'Docs' do
    it "displays the README" do
      get "/docs"
      expect(last_response.body).to include("Mandrill Merge")
    end
  end

  describe 'Mandrill connection' do
    let(:happy_mandrill) { double(:can_connect? => true, :username => 'Tilly') } 
    let(:sad_mandrill)   { double(:can_connect? => false, :username => nil) }

    subject(:response) do
      post "/verify-mandrill", {'key' => 'test'}
    end

    context 'can connect using the provided api key' do
      before { expect(Mandrill).to receive(:new).with('test').and_return(happy_mandrill) }
      
      it "displays connection successful" do
        expect(response.body).to include("Connection successful")
      end

      it "displays the username" do
        expect(response.body).to include("Tilly")
      end
    end

    context 'cannot connect using the provided api key' do
      before { expect(Mandrill).to receive(:new).with('test').and_return(sad_mandrill) }
      
      it "displays connection unsuccessful" do
        expect(response.body).to include("Connection unsuccessful")
      end
    end
  end

end
