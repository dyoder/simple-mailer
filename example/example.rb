require "../lib/simple_mailer"

SimpleMailer.template_directory = "templates"
SimpleMailer.domain = "mail.acme.com"
SimpleMailer.host = "smtp.acme.com"
SimpleMailer.port = 25
SimpleMailer.username = "foo@bar.com"
SimpleMailer.password = "baz"

class MyMailer < SimpleMailer
	def initialize(name, email)
		super(:from => "The Management <admin@acme.com>",:to => email, 
			:subject =>"Welcome #{name}", :name => name, :template => :test)
	end
end

MyMailer.new("Joe","Joe <joe@acme.com>").deliver!