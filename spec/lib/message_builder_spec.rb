require 'spec_helper'

describe MessageBuilder do
  it 'builds the message data for sending a single email with placeholders' do
    actual_message = MessageBuilder.build_single('template', 'recipient@example.com', [{name: 'placeholder1', content: 'value1'}, {name: 'placeholder2', content: 'value2'}])
    expected_message = {
      template_name: 'template',
      # Template doesn't actually need values, but API does.
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient@example.com'}],
        merge: true,
        merge_vars: [{rcpt: 'recipient@example.com', vars: [{name: 'placeholder1', content: 'value1'}, {name: 'placeholder2', content: 'value2'}] }] } }  
    expect(actual_message).to eq expected_message
  end

  it 'builds the message data for sending a single email without placeholders' do
    actual_message = MessageBuilder.build_single('template', 'recipient@example.com', nil)
    expected_message = {
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient@example.com'}] } }  
    expect(actual_message).to eq expected_message
  end

  it 'builds the message data for sending a single email with empty placeholders' do
    actual_message = MessageBuilder.build_single('template', 'recipient@example.com', [])
    expected_message = {
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient@example.com'}] } }  
    expect(actual_message).to eq expected_message
  end

  it 'builds the message data for sending a batch of emails with placeholders' do
    actual_message = MessageBuilder.build_batch('template', ['recipient1@example.com', 'recipient2@example.com'], 
      [
        [{name: 'placeholder1', content: 'value1.1'}, {name: 'placeholder2', content: 'value1.2'}],
        [{name: 'placeholder1', content: 'value2.1'}, {name: 'placeholder2', content: 'value2.2'}]
      ])
    expected_message = { 
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient1@example.com'}, {email: 'recipient2@example.com'}],
        merge: true,
        merge_vars: [
          {rcpt: 'recipient1@example.com', vars: [{name: 'placeholder1', content: 'value1.1'}, {name: 'placeholder2', content: 'value1.2'}] },
          {rcpt: 'recipient2@example.com', vars: [{name: 'placeholder1', content: 'value2.1'}, {name: 'placeholder2', content: 'value2.2'}] }
        ]       
      } 
    }
    expect(actual_message).to eq expected_message
  end

  it 'does not flatten arrays with a single element' do
    actual_message =  MessageBuilder.build_batch('bizzz-refund',
      ['mary-anne.cosgrove@envato.com', 'steven.douglas@envato.com'],
      [[{name: 'FULLNAMEORUSERNAME', content: 'Mary-Anne'}], [{name: 'FULLNAMEORUSERNAME', content: 'Steven D'}]]
    )
    expected_message = {
      :template_name => "bizzz-refund",
      :template_content => [{:name=>"stupid", :value=>"api"}],
      :message => {
        :to => [{:email=>"mary-anne.cosgrove@envato.com"}, {:email=>"steven.douglas@envato.com"}],
        :merge => true,
        :merge_vars => [
          {:rcpt=>"mary-anne.cosgrove@envato.com", :vars=>[{:name=>"FULLNAMEORUSERNAME", :content=>"Mary-Anne"}]},
          {:rcpt=>"steven.douglas@envato.com", :vars=>[{:name=>"FULLNAMEORUSERNAME", :content=>"Steven D"}]}
        ]}}
    expect(actual_message).to eq expected_message
  end

   it 'builds the message data for sending a batch of emails with empty placeholders' do
    actual_message = MessageBuilder.build_batch('template', ['recipient1@example.com', 'recipient2@example.com'], [])
    expected_message = { 
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient1@example.com'}, {email: 'recipient2@example.com'}]      
      } 
    }  
    expect(actual_message).to eq expected_message
  end

 context "when there are a different number of email addresses than placeholder value sets" do
    it 'raises an error' do
      expect { MessageBuilder.build_batch('template', ['fred@example.com'], 
        [
          [{ name: 'FIRSTNAME', content: 'FRED' }, { name: 'SURNAME', content: 'BASSETT' }],
          [{ name: 'FIRSTNAME', content: 'HANS' }, { name: 'SURNAME', content: 'OLO' }]
        ]) 
      }.to raise_error(MessageBuilder::DataMismatch)
    end
  end  

end
