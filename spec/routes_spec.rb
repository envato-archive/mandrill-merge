require 'spec_helper'

describe 'routes' do

  let(:mandrill) { double(Mandrill, can_connect?: true, username: 'user') }

  before { allow(Mandrill).to receive(:new).and_return(mandrill) }
  
  subject(:json_hash) { JSON.parse(last_response.body) }

  describe '#verify-mandrill' do

    context "Can connect to Mandrill as 'user'" do
      it 'returns json with expected keys' do
        post '/verify-mandrill', {:key => 'test'}
        expect(json_hash['can_connect']).to be true
        expect(json_hash['message']).to include 'user'
      end
    end

    context "Cannot connect to Mandrill" do
      
      let(:mandrill) { double(Mandrill, can_connect?: false) }
      
      it 'returns an error message' do
        post '/verify-mandrill', {:key => 'test'}
        expect(json_hash['can_connect']).to be false
        expect(json_hash['message']).to include 'Cannot connect to Mandrill'
      end
    end
  end

  describe '#select-template' do

    context 'a valid published template' do
      before { post '/select-template', {:template => 'the_template'}, 'rack.session' => {key: 'key'} }

      context 'with merge tags' do
        let(:merge_tags) { ['TAG1', 'TAG2'] }
        let(:mandrill) { double(Mandrill, fetch_merge_tags: merge_tags) }

        it 'succeeds' do
          expect(json_hash['success']).to be true
        end

        it 'sets the template name in the response message' do
          expect(json_hash['message']).to include 'the_template'
        end

        it 'saves the merge tags in the session' do
          expect(json_hash['merge_tags']).to include merge_tags.join(', ')
        end
      end

      context 'without merge tags' do
        let(:mandrill) { double(Mandrill, fetch_merge_tags: []) }

        it 'succeeds' do
          expect(json_hash['success']).to be true
        end

        it 'sets the template name in the response message' do
          expect(json_hash['message']).to include 'the_template'
        end
      end
    end
      
    context 'a valid unpublished template' do
      let(:mandrill) { double(Mandrill, fetch_merge_tags: []) }
      before do
        allow(mandrill).to receive(:fetch_merge_tags).and_raise(Mandrill::UnpublishedTemplate, I18n.t(:unpublished_template))
        post '/select-template', {:template => 'the_template'}, 'rack.session' => {key: 'key'}
      end

      it 'fails' do
        expect(json_hash['success']).to be false
      end

      it 'informs the user the template has not been published' do
        expect(json_hash['message']).to include 'seems to be unpublished'
      end
    end
    
    context 'an invalid template' do
      let(:mandrill) { double(Mandrill, fetch_merge_tags: []) }
      before do
        allow(mandrill).to receive(:fetch_merge_tags).and_raise(Mandrill::MandrillError, 'No such template "the_template"')
        post '/select-template', {:template => 'the_template'}, 'rack.session' => {key: 'key'}
      end

      it 'fails' do
        expect(json_hash['success']).to be false
      end

      it 'returns the error message from Mandrill' do
        expect(json_hash['message']).to include 'No such template "the_template"'
      end
    end
    
  end

  describe '#set-db-query' do
    let(:reader) { double('reader').as_null_object }
    before do
      expect(reader).to receive(:count).and_return(55)
      Database.stub_chain(:connection, :create_command, :execute_reader).and_return(reader)
      post '/set-db-query', {:db_query => 'some query'}
    end

    it 'succeeds' do
      expect(json_hash['success']).to be true
    end

    it 'sets the db query in the response message' do
      expect(json_hash['message']).to include '55 records returned'
    end
  end
  
  describe 'send-test' do

    let(:params) {}
    let(:session) {}
    let(:reader) { double('reader').as_null_object }

    before do
      Database.stub_chain(:connection, :create_command, :execute_reader).and_return(reader)
      allow(TemplateFieldMerger).to receive(:merge_fields).and_return([])

      post '/send-test', params, 'rack.session' => session
    end

    context 'when session contains the mandrill key and template name' do
      let(:session) { {key: 'key', template: 'template'} }
    
      context 'and user has entered a valid email address' do
        let(:params) { {:email => 'someone@somewhere.com'} } 

        context 'and mandrill can connect' do
          context 'and mandrill can send the email' do
            let(:mandrill) { double(Mandrill, can_connect?: true, username: 'user', send_single_email: [{"email"=>params[:email], "status"=>"sent", "_id"=>"xyz", "reject_reason"=>nil}]) }

            it 'provides a happy message' do
              expect(json_hash['success']).to be true
              expect(json_hash['message']).to include 'Test email sent.'
            end
          end

          context 'but mandrill cannot send the email' do
            let(:mandrill) { double(Mandrill, can_connect?: true, username: 'user', send_single_email: {"status"=>"error", "code"=>5, "name"=>"Unknown_Template", "message"=>"Some error from Mandrill"}) }
            it 'provides the error message from Mandrill' do
              expect(json_hash['success']).to be false
              expect(json_hash['message']).to include 'Some error from Mandrill'
            end
          end
         context "but mandrill cannot send the email and doesn't supply an error message" do
            let(:mandrill) { double(Mandrill, can_connect?: true, username: 'user', send_single_email: {"status"=>"error"}) }
            it 'provides our own error message' do
              expect(json_hash['success']).to be false
              expect(json_hash['message']).to include 'Mandrill could not send the email.'
            end
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
