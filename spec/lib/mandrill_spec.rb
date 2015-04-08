require 'spec_helper'

describe 'our Mandrill' do

  let(:templates_info_response) { {} }
  let(:happy_chimp) { double(:valid_api_key? => true, :users_info => {'username' => 'Bubbles'}, :templates_info => templates_info_response) } 
  let(:sad_chimp) { double(:valid_api_key? => false) } 

  subject(:mandrill) { Mandrill.new }

  context 'can connect to Mandrill' do
    before { expect(Mailchimp::Mandrill).to receive(:new).and_return(happy_chimp) }

    it 'should connect using the API key from the environment by default' do
      expect(mandrill.can_connect?).to be true
    end
    
    it 'should retrieve the username' do
      expect(mandrill.username).to eq 'Bubbles'
    end

    describe '#fetch_merge_tags' do
      context 'when a valid template is provided' do
        let(:templates_info_response) { {"slug"=>"template", "name"=>"The Template", "publish_code"=>"<!DOCTYPE ...<p>Hello *|FULLNAMEORUSERNAME|*</p><p>...*|ANOTHERPLACEHOLDER|*...", "publish_from_name"=>"The Envato Team", "code"=>"something else"} }
        
        it 'extracts the merge tags' do
          expect(mandrill.fetch_merge_tags('template')).to eq ['FULLNAMEORUSERNAME', 'ANOTHERPLACEHOLDER']
        end
      end 

      context 'when the template has no placeholders' do
        let(:templates_info_response) { {"slug"=>"template", "name"=>"The Template", "publish_code"=>"something"} }
        
        it 'returns an empty array' do
          expect(mandrill.fetch_merge_tags('xxx')).to eq []
        end
      end 

      context 'when the template is not published' do
        let(:templates_info_response) { {"slug"=>"template", "name"=>"The Template", "code"=>"something else"} }
        
        it 'returns nil' do
          expect(mandrill.fetch_merge_tags('xxx')).to be_nil
        end
      end 


      context 'when an invalid template is provided' do
        let(:templates_info_response) { {"status"=>"error", "code"=>5, "name"=>"Unknown_Template", "message"=>'No such template "xxx"'} }
        
        it 'returns the whole error response' do
          expect(mandrill.fetch_merge_tags('xxx')).to eq({"status"=>"error", "code"=>5, "name"=>"Unknown_Template", "message"=>'No such template "xxx"'})
        end
      end 
    end 

  end

  context 'cannot connect to Mandrill' do
    before { expect(Mailchimp::Mandrill).to receive(:new).and_return(sad_chimp) }

    it 'should return false' do
      expect(mandrill.can_connect?).to be false
    end

    it 'should not attempt to retrieve the username' do
      expect(sad_chimp).not_to receive(:users_info)
      mandrill.username
    end 
  end

end