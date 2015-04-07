require 'spec_helper'

describe 'routes' do

  let(:mandrill) { double(Mandrill, can_connect?: true, username: 'user') }

  before { allow(Mandrill).to receive(:new).and_return(mandrill) }
  
  describe '#verify-mandrill' do

    context "Can connect to Mandrill as 'user'" do
      it 'returns json with expected keys' do
        post '/verify-mandrill', {:key => 'test'}
        json_hash = JSON.parse(last_response.body)
        expect(json_hash['can_connect']).to be true
        expect(json_hash['message']).to include 'user'
      end
    end

    context "Cannot connect to Mandrill" do
      
      let(:mandrill) { double(Mandrill, can_connect?: false) }
      
      it 'returns an error message' do
        post '/verify-mandrill', {:key => 'test'}
        json_hash = JSON.parse(last_response.body)
        expect(json_hash['can_connect']).to be false
        expect(json_hash['message']).to include 'Cannot connect to Mandrill'
      end
    end
  end

  describe '#select-template' do
    it 'succeeds' do
      post '/select-template', {:template => 'anything'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['success']).to be true
    end

    it 'sets the template name in the response message' do
      post '/select-template', {:template => 'the_template'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['message']).to include 'the_template'
    end
  end

  describe '#set-db-query' do
    it 'succeeds' do
      post '/set-db-query', {:db_query => 'some query'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['success']).to be true
    end

    it 'sets the db query in the response message' do
      post '/set-db-query', {:db_query => 'some query'}
      json_hash = JSON.parse(last_response.body)
      expect(json_hash['message']).to include 'some query'
    end
  end
  
  describe 'send-test' do

    let(:params) {}
    let(:session) {}

    before { post '/send-test', params, 'rack.session' => session }

    subject(:json_hash) { JSON.parse(last_response.body) }

    context 'when session contains the mandrill key and template name' do
      let(:session) { {key: 'key', template: 'template'} }
    
      context 'and user has entered a valid email address' do
        let(:params) { {:email => 'someone@somewhere.com'} } 

        context 'and mandrill can connect' do
          it 'sends the email request' do
            expect(json_hash['success']).to be true
            expect(json_hash['message']).to include 'Test email sent.'
          end
        end

        context 'but mandrill cannot connect' do
          let(:mandrill) { double(Mandrill, can_connect?: false) }
          it 'returns an error message' do
            expect(json_hash['can_connect']).to be false
            expect(json_hash['message']).to include 'try again later'
          end
        end
      end

      context 'but user has not entered an email address' do
        let(:params) { {} }
        it 'returns an error message' do
          expect(json_hash['success']).to be false
          expect(json_hash['message']).to include 'Please enter a valid email address'
        end  
      end

      context 'but user has entered an invalid email address' do
        let(:params) { {:email => 'someone'} }
        it 'returns an error message' do
          expect(json_hash['success']).to be false
          expect(json_hash['message']).to include 'Please enter a valid email address'
        end
      end

    end

    context 'when session contains no mandrill key' do
      let(:session) { {template: 'template'} }
    
      it 'returns an error message' do
        expect(json_hash['can_connect']).to be false
        expect(json_hash['message']).to include 'enter your Mandrill key'
        expect(json_hash['goto_section']).to eq 'connect_mandrill'
      end
    end

    context 'when session contains no template' do
      let(:session) { {key: 'key'} }
    
      it 'returns an error message' do
        expect(json_hash['can_connect']).to be false
        expect(json_hash['message']).to include 'select your Mandrill template'
        expect(json_hash['goto_section']).to eq 'select_template'
      end
    end
  end    
end
