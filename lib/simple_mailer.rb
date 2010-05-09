require 'rubygems'
require 'net/smtp'
require 'erubis'

class SimpleMailer
	
	attr_reader :options
	def initialize(options) ; @options = options ; end
	def content ; self.class.content(options) ; end
	def deliver! ; self.class.deliver!(options) ; end
	
	class << self 
		
		%w( template_directory domain host port username password ).each do |method|
			define_method(method) { instance_variable_get("@#{method}")||superclass.send(method)  }
			define_method("#{method}=") { |val| instance_variable_set("@#{method}",val) }
		end
		
		def templates ; @templates ||= {} ; end
		
		def content(options)
			# Note that the lazy eval here makes it possible for the body or even the entire
			# message to be passed as an option, bypassing the template mechanism;
			# in any case, it prevents anything from being evaluated twice
			options[:body] ||= template(options[:template]).result(options)
			options[:content] ||= template(:_content).result(options)
		end
		
		def deliver!(options)
			# We assume you'll want to deal with exceptions in the client code
			Net::SMTP.start(host,port,domain,username,password,:plain) do |smtp|
				from,to = options.values_at(:from,:to)
				smtp.send_message(content(options),from,to)
			end
		end
		
		private
		
		# keep the compiled templates in memory
		def template(name)
			templates[name.to_sym] ||= 
				Erubis::Eruby.new(File.read(File.join(template_directory,"#{name}.erb")))
		end

	end
	
end