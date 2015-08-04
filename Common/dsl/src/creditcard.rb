#USAGE 
# from the script you need to require 'CreditCard'
# to generate a card use:
# ccard = CreditCard.new
# mastercard = ccard.mastercard
# visa = ccard.visa
# amex = ccard.amex
# discover = ccard.discover
# purfree = ccard.purfree
# purpaid = ccard.purpaid

class CreditCard

  #Set the prefixes for specific test cards	
  #https://www.bindb.com/bin-list.html
  #added plcc, purfree and purpaid mod10 for card generation.  plcc is not currently supported.
  @named = {
      :mastercard => {:prefixes => ['510040', '512000', '522182', '532561', '546604', '553823', '560054'], :size => 16},
      :visa => {:prefixes => ['409311', '410897', '412134', '415874', '411773'], :size => 16},
      :amex => {:prefixes => ['34', '377481', '372888', '3764'], :size => 15},
      :discover => {:prefixes => ['6011'], :size => 16},
      :purcc => {:prefixes => ['778840'], :size => 16},
      :purfree => {:prefixes => ['3975'], :size => 13},
      :purpaid => {:prefixes => ['3976'], :size => 13}
  }

  def self.valid?(candidate)
    calc_modulus(candidate) == 0
  end

  def self.generate(string_size, options={})
    raise ArgumentError, "prefix must be numeric" if options[:prefix] && !(options[:prefix] =~ /^\d*$/)

    output = options[:prefix] || ''
    (string_size-output.size-1).times do |n|
      output += rand(10).to_s
    end
    output += '0'

    if options[:invalid]
      case calc_modulus(output)
        when 0
          output = output[0...-1] + (rand(8) + 1).to_s
        when [1..8]
          output = output[0...-1] + ((10 - calc_modulus(output))/2).to_s
        when 9
          output = output[0...-1] + (rand(7) + 2).to_s
      end
    else
      unless calc_modulus(output) == 0
        output = output[0...-1] + (10 - calc_modulus(output)).to_s
      end
    end

    output
  end

  def self.method_missing(type, *args)
    pattern_name, method_type = parse_method_name(type)

    raise NoMethodError unless @named[pattern_name] && @named[pattern_name][:prefixes] && @named[pattern_name][:size]

    send(method_type, *(args.unshift(pattern_name)))
  end

  private
  def self.double_and_fix(number)
    2 * number > 9 ? ((2 * number) % 10 + 1) : 2 * number
  end

  def self.calc_modulus(candidate)
    working = candidate.reverse
    double_up = false;
    sum = 0

    working.each_char do |ch|
      num = ch.to_i
      sum += double_up ? double_and_fix(num) : num
      double_up = !double_up
    end

    sum % 10
  end

  def self.parse_method_name(method_name)
    method_name = method_name.to_s
    case method_name
      when /(.*)\?$/
        [$~[1].to_sym, :valid_pattern?]
      else
        [method_name.to_sym, :generate_pattern]
    end
  end

  def self.generate_pattern(pattern_name, options={})
    generate(@named[pattern_name][:size], options.merge({:prefix => @named[pattern_name][:prefixes][rand(@named[pattern_name][:prefixes].size)]}))
  end

end