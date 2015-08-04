#service account password hash creator
#http://security.stackexchange.com/questions/5504/what-are-the-most-common-password-salting-methods
#http://ruby-doc.org/stdlib-2.0/libdoc/base64/rdoc/Base64.html
#http://ruby-doc.org/stdlib-1.9.3/libdoc/openssl/rdoc/OpenSSL/HMAC.html



require 'digest'
require 'openssl'
require 'base64'
require 'securerandom'
require 'digest/hmac'

class TheKeyMaker

	def get_the_params
		password_parameter
	end
	
	def salty_hash(password, work_factor)

	  password = password.force_encoding(Encoding::ASCII_8BIT) if defined?(Encoding)
	  hash = OpenSSL::Digest::SHA256.new
	  salt = SecureRandom.random_bytes(hash.new.block_length)
	  hmac = OpenSSL::HMAC.new(salt, hash)
	  passme = []
	  iterations = 2 ** work_factor
	  iterations.times do
	  #hmac.digest isn't working right... hrmph.  looking into it before finding a new solution.
		passme = hmac.digest
	  end

	  # return the salt and the hashed password to whoever called
	  # this method
	  {:salt => salt, :hash => passme, :work => work_factor}
	  return passme
	end
	
	def put_the_hash_on_the_file_or_it_gets_the_hose_again
		file_path = "#{ENV['QAAUTOMATION_SCRIPTS']}/KeyBox/GSs_dbtest01849a51k1tt3hn521d5d5s6QA.txt"
		Dir.mkdir(path) unless File.exists?(file_path)
	end
	
	def read_hashed_pass(file_path)
		sha1 = OpenSSL::Digest::SHA1.new
		
		File.open(file_path) do|file|
			buffer = ''
				while not file.eof
					Base64.decode(enc)
					file.read(512, buffer)
					sha1.update(buffer)
				end
			end
			
		puts sha1
	end
	
end

m = TheKeyMaker.new
# how to call the method
puts m.salty_hash("passwordtohash", 2)






