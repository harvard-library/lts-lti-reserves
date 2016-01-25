# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [:password, :oauth_consumer_key,:custom_canvas_user_login_id, :lis_person_contact_email_primary, :lis_person_name_family, :lis_person_name_full, :lis_person_name_given, :lis_person_sourcedid ]
