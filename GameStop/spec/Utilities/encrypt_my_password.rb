require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/spec/utilities/aes_encryption.rb"

password = 'mypassword'
value = AES.encrypt(password)
puts "Encrypted with random IV " << value[:iv] << ": " << value[:content]

#dbpass = AES.decrypt("kBr++QdEiKlO9Y37n4fsDA==", {iv: "+ehB/UFhGCq7bLbw3hq/mw=="})[:content]
#puts "Decrypted password is : #{dbpass}"