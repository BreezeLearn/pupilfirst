# require "spec_helper"

# describe 'StartupMailer' do
#   include Rails.application.routes.url_helpers

#   context 'shoot out emails to all founders' do
#     let(:startup) { create :startup}
#     let(:new_employee) { create :user_with_out_password}
#     let(:email) { StartupMailer.respond_to_new_employee(startup, new_employee) }

#     it "with to set as founders email" do
#       expect(email).to deliver_to(startup.founders.map { |e| "#{e.fullname} <#{e.email}>" })
#     end

#     it "with body containing a link to the confirmation link" do
#       expect(email).to have_body_text(confirm_employee_startup_url(startup, token: new_employee.startup_verifier_token))
#     end
#   end
# end
