# Encrypt input using AES
require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/spec/utilities/aes_encryption.rb"

if ARGV.empty?
  print "Encrypts input using AES (CBC)\nSyntax: #{$0} content [iv (Base64)] [key (Base64)] [key_length (128)]"
  exit
elsif ARGV.length == 1
  result = AES.encrypt(ARGV[0])
elsif ARGV.length == 2
  result = AES.encrypt(ARGV[0], {iv: ARGV[1]})
elsif ARGV.length == 3
  result = AES.encrypt(ARGV[0], {iv: ARGV[1], key: ARGV[2]})
else
  result = AES.encrypt(ARGV[0], {iv: ARGV[1], key: ARGV[2], key_length: ARGV[3]})
end
print "Content:\n" + ARGV[0] + "\n\nEncrypted:\n" + result[:content] + "\n\nIV:\n" + result[:iv]
print "\n\nTo use:\nAES.decrypt(\"#{result[:content]}\", {iv: \"#{result[:iv]}\"" + (ARGV.length > 2 ? ", key: \"#{ARGV[2]}\"" : "") + "})[:content]"