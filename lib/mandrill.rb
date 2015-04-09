require 'mailchimp'
require 'logger'

class Mandrill

  # Mailchimp and mandrill use the same API gem.

  def self.api_key
    ENV.fetch("MANDRILL_API_KEY")
  end

  def initialize(key=nil)
    # By default mandrill sneak in some options, the empty hash overrides.
    @key = key || Mandrill.api_key
    @mandrill ||= Mailchimp::Mandrill.new(@key, options: {})
    Dir.mkdir('logs') unless File.exist?('logs')

    @logger = Logger.new('logs/common.log','weekly')
    @logger.level = Logger::DEBUG  
  end

  def can_connect?
    @can_connect ||= @mandrill.valid_api_key?
  end

  def username
    user_details["username"] if user_details
  end

  def user_details
    @user_details ||= @mandrill.users_info if can_connect?
  end

  def send_single_email(template, send_to, data)
    message_data = MessageBuilder.build_single(template, send_to, data)
    @logger.debug("Sending message: #{message_data.inspect}")
    send_template(message_data).tap { |response| @logger.debug("Response: #{response}") }
  end

  def fetch_merge_tags(template)
    @logger.debug("Getting template info: #{template}")
    response = @mandrill.templates_info({key: @key, name: template})
    @logger.debug("Response: #{response}")
    raise MandrillError.new(response["message"]) if response["status"] == "error"
    published_template_code = response["publish_code"]
    raise UnpublishedTemplate.new("#{template} #{I18n.t :unpublished_template}") if published_template_code == nil || published_template_code.empty?
    published_template_code.scan(/\*\|(.*?)\|\*/).flatten
  end  

  private

  def send_template(message_data)
    @mandrill.messages_send_template(message_data)
  end

  class MandrillError < StandardError
  end

  class UnpublishedTemplate < StandardError
  end

end
