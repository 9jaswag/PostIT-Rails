class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@postit.herokuapp.com'
  layout 'mailer'
end
