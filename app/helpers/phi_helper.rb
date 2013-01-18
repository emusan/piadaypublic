module PhiHelper
  # I realize that the code here is hardly memory efficient, or even 
  # remotely well optomized, but this isn't exactly a high strain app 
  # at this point, with just a user or two this wont really hurt much.

  # yes it's not formatted properly for linebreaks, oh well
  REALPHI = BigDecimal.new("1.61803398874989484820458683436563811772030917980576286213544862270526046281890244970720720418939113748475408807538689175212663386222353693179318006076672635443338908659593958290563832266131992829026788")

  REALPHIARRAY = REALPHI.to_s.scan(/\d/)

  def phi_to_digits(number)
    @phiarray = to_array(number)
    REALPHIARRAY.each_index do |index|
      if REALPHIARRAY[index] != @phiarray[index]
        return index
      end
    end
  end

  def digits_to_phi(number)
    REALPHIARRAY.first(number).join(' ')
  end

  def next_digit(number)
    REALPHIARRAY[number]
  end

  def to_array(longnum)
    longnum.to_s.scan(/\d/)
  end

  def phi_days_to_next_test
    numdays = (@phi.next_test - Time.now) / (24 * 60 * 60)
    numdays.truncate
  end
end
