class MessageBuilder

  def self.build_single(template, recipient_email, recipient_data)
    message = {to: [{email: recipient_email}]}
    if recipient_data && !recipient_data.empty?
      message[:merge] = true 
      message[:merge_vars] = [{rcpt: recipient_email, vars: recipient_data }]
    end
    {
      template_name: template,
      # Template doesn't actually need values, but API does.
      template_content: [{name: "stupid", value: "api"} ],
      message: message 
    }  
  end

end
