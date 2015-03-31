require 'mailchimp'

class Mandrill

  # Mailchimp and mandrill use the same API gem.

  def self.api_key
    ENV.fetch("MANDRILL_API_KEY")
  end

  def initialize(key=nil)
    # By default mandrill sneak in some options, the empty hash overrides.
    key ||= Mandrill.api_key
    @mandrill ||= Mailchimp::Mandrill.new(key, options: {})
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

end