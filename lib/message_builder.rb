class MessageBuilder

  def self.build_single(template, recipient_email, recipient_data)
    recipient_array = recipient_data ? [recipient_data] : nil
    build_batch(template, [recipient_email], recipient_array)
  end

  def self.build_batch(template, emails, merged_template_data)
    recipient_emails = emails.inject([]) {| array, email | array << {email: email} }
    message = {to: recipient_emails}
    if merged_template_data && !merged_template_data.flatten.empty?
      message[:merge] = true 
      message[:merge_vars] = merge_vars(emails, merged_template_data)
    end
    {
      template_name: template,
      # Template doesn't actually need values, but API does.
      template_content: [{name: "stupid", value: "api"} ],
      message: message 
    }    
  end

  def self.merge_vars(emails, merged_template_data)
    raise DataMismatch.new('Code error: emails and merged template data must have the same size!') if data_mismatch(emails, merged_template_data)
    merge_vars = []
    emails.each_index do |index|
      merge_vars << { rcpt: emails[index], vars: merged_template_data[index]}
    end
    merge_vars
  end

  def self.data_mismatch(emails, merged_template_data)
    (emails.size != merged_template_data.size) && (merged_template_data.size > 0)
  end

  class DataMismatch < StandardError
  end

end
