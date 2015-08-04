# This file contains the domain specific language (DSL) methods for interacting
# with the Game Stop website.
#
# Author:: Ecommerce QA
# Copyright:: Copyright (c) 2013 GameStop, Inc.
# Not for external distribution.

# Class built specifically for testing the enterprise password regex
# 1 in 100,000 passwords may fail due to the shuffling of the arrays
# This is temp code for a quick test, will refactor to a proper solution in time
require 'securerandom'

class PasswordGenerator

  ### GENERATE PASSWORD AND VERIFY PASSWORD REGEX ###
  def random_number(n = 0)
    SecureRandom.random_number(n)
  end

  def sample_array(array)
    array[random_number(array.size)]
  end

  def shuffle_array(array)
    array.sort_by { random_number }
  end

  def generate_password(size)
    $tracer.trace("PasswordGenerator: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    #research https://github.com/patdeegan/keepass-password-generator
    upper = %w(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
    lower = %w(a b c d e f g h i j k l m n o p q r s t u v w x y z)
    digits = %w(0 1 2 3 4 5 6 7 8 9)
    ascii_specials = %w(% $ @ #)
    #high_ansi = (0x7f..0xfe).map { |i| i.chr }.join

    build1 = [(upper).sample(2), (digits).sample(2)]
    build2 = [(lower).sample(2), (digits).sample(2), ascii_specials.sample(2)]
    build3 = [ascii_specials.sample(2)]
    build4 = [upper.sample(2), lower.sample(2), digits.sample(2), ascii_specials.sample(2)]
    build5 = [digits.sample(2), ascii_specials.sample(1)]

    pwd = [self.shuffle_array(build1), self.shuffle_array(build2), self.shuffle_array(build3), self.shuffle_array(build4), self.shuffle_array(build5)]
    pwd_length = pwd.flatten.length - 1
    $tracer.trace(pwd)
    password = (0..size).collect{|i| pwd[rand(random_number(n=pwd_length))]}.join
    password = ("#{lower.sample(1).join}#{password}#{ascii_specials.sample(1).join}")
    password[0..(size - 1)]
  end

  def verify_password(password)
    $tracer.trace("PasswordGenerator: #{__method__}, Line #{__LINE__}")
    $tracer.report("Should #{__method__}.")
    pwd_regex = '^(?:(?:(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]))|(?:(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%\\*]))|(?:(?=.*[0-9])(?=.*[A-Z])(?=.*[!@#$%\\*]))|(?:(?=.*[0-9])(?=.*[a-z])(?=.*[!@#$%\\*])))(\S(?:[a-zA-Z0-9!@#$%\\*]*){8,64})$'
    $tracer.trace("Password RegEx Pattern #{pwd_regex}")
    password.match(pwd_regex) ? status = true : status = false
    pwd_len = password.length
    return status, pwd_len
  end

end