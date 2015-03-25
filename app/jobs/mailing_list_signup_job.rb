class MailingListSignupJob < ActiveJob::Base

	def perform(visitor)
		mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
		result = mailchimp.lists.subscribe({
			:id => Rails.application.secrets.mailchimp_list_id,
			:email => {:email => visitor.email},
			:double_optin => false,
			:update_existing => true,
			:send_welcome => true
			})
			Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
	end

end