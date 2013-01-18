module PiHelper
  # I realize that the code here is hardly memory efficient, or even 
  # remotely well optomized, but this isn't exactly a high strain app 
  # at this point, with just a user or two this wont really hurt much.

  # yes it's not formatted properly for linebreaks, oh well
  REALPI = BigDecimal.new("3.14159265358979323846264338327950288419716939937510582097494459230781640628620899862803482534211706798214808651328230664709384460955058223172535940812848111745028410270193852110555964462294895493038196")

  REALPIARRAY = REALPI.to_s.scan(/\d/)

  def pi_to_digits(number)
    @piarray = to_array(number)
    REALPIARRAY.each_index do |index|
      if REALPIARRAY[index] != @piarray[index]
        return index
      end
    end
  end

  def digits_to_pi(number)
    REALPIARRAY.first(number).join(' ')
  end

  def next_digit(number)
    REALPIARRAY[number]
  end

  def to_array(longnum)
    longnum.to_s.scan(/\d/)
  end

  def pi_days_to_next_test
    numdays = (@pi.next_test - Time.now) / (24 * 60 * 60)
    numdays.truncate
  end
end
