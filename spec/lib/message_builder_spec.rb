require 'spec_helper'

describe MessageBuilder do
  it 'should build the message data for sending a single email with placeholders' do
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

  it 'should build the message data for sending a single email without placeholders' do
    actual_message = MessageBuilder.build_single('template', 'recipient@example.com', nil)
    expected_message = {
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient@example.com'}] } }  
    expect(actual_message).to eq expected_message
  end

  it 'should build the message data for sending a single email with empty placeholders' do
    actual_message = MessageBuilder.build_single('template', 'recipient@example.com', [])
    expected_message = {
      template_name: 'template',
      template_content: [{name: "stupid", value: "api"} ],
      message: {
        to: [{email: 'recipient@example.com'}] } }  
    expect(actual_message).to eq expected_message
  end
end
