class MailingListSignupJob < ActiveJob::Base

	def perform(visitor)
		mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
		result = mailchimp.lists.subscribe({
			:id => Rails.application.secrets.mailchimp_list_id,
			:email => {:email => visitor.email},
			:merge_vars => {:referrer => visitor.referrer.truncate(252, omission: '....'),
											:groupings => [{:name => 'AFFINITY',
																			:groups => [visitor.affinity.upcase]
																		}]
											},
			:double_optin => false,
			:update_existing => true,
			:send_welcome => true
			})
			Rails.logger.info("Subscribed #{visitor.email} to MailChimp") if result
	end

end