require "#{ENV['QAAUTOMATION_SCRIPTS']}/GameStop/spec/utilities/aes_encryption.rb"

describe "Test AES Encrypt Decrypt" do

  it "should encrypt and decrypt a password" do
      password = 'mypassword'
      value = AES.encrypt(password)
      puts "Encrypted with random IV " << value[:iv] << " : " << value[:content]

      dbpass = AES.decrypt(value[:content], {iv: value[:iv]})[:content]
      puts "Decrypted password is : #{dbpass}"

      dbpass.should == password
  end

end