# AES encryption library
# Permits use of passwords within script without plaintext password
# Inputs are base64 encoded
require 'openssl'
require 'digest/sha1'
require 'base64' # Because dealing with encoding in scripts is a mess for users

# Usage:
# text = "The quick brown fox jumps over the lazy dog."
# puts "Plaintext: " << text
#
# encrypted = AES.encrypt(text, {iv: "12345678123456781234567"})
# puts "Encrypted with IV " << encrypted[:iv] << ": " << encrypted[:content]
# 
# decrypted = AES.decrypt(encrypted[:content], :iv => encrypted[:iv])
# puts "Decrypted: " << decrypted[:content]
# 
# encrypted = AES.encrypt(text)
# puts "Encrypted with random IV " << encrypted[:iv] << ": " << encrypted[:content]
# 
# decrypted = AES.decrypt(encrypted[:content], :iv => encrypted[:iv])
# puts "Decrypted: " << decrypted[:content]
#
# In an actual app:
# value = password
# value = AES.decrypt("aG3i3Uy21gOR+pnrHVyc+Q==", {iv: "5OkXaq/i80wDldpDH+Dz8Q=="})[:content]
module AES

	def self.encrypt(content, options = {})
		options[:encrypt] = true
		cipher = setup_AES_cipher(options)

		{content: Base64.strict_encode64(cipher[:cipher].update(content) << cipher[:cipher].final), iv: cipher[:options][:iv]}
	end
		
	def self.decrypt(content, options = {})
		options[:encrypt] = false
		cipher = setup_AES_cipher(options)
		content = Base64.strict_decode64(content)
	
		{content: cipher[:cipher].update(content) << cipher[:cipher].final}
	end
	
private
		# AES above 128 requires unlimited cryptographic authorization
		AES_DEFAULTS = {
			:key => Base64.strict_encode64("Sfk2yt%z!kvIojd@"),
			:key_length => 128,
			:block_mode => "cbc"
		}

		def self.setup_AES_cipher(options)
			options = AES_DEFAULTS.merge(options)
			
			cipher = OpenSSL::Cipher::Cipher.new("aes-" << options[:key_length].to_s << "-" << options[:block_mode])
			options[:encrypt]? cipher.encrypt : cipher.decrypt
			cipher.key = Digest::SHA1.hexdigest(Base64.strict_decode64(options[:key]))
			# Use the IV set in options if it exists, else set a random IV and store it in options
			options[:iv]? cipher.iv = Base64.strict_decode64(options[:iv]) : options[:iv] = Base64.strict_encode64(cipher.random_iv)

			{cipher: cipher, options: options}
		end
end