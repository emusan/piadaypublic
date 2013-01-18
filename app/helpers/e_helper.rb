module EHelper
  # I realize that the code here is hardly memory efficient, or even 
  # remotely well optomized, but this isn't exactly a high strain app 
  # at this point, with just a user or two this wont really hurt much.

  # yes it's not formatted properly for linebreaks, oh well
  REALE = BigDecimal.new("2.71828182845904523536028747135266249775724709369995957496696762772407663035354759457138217852516642742746639193200305992181741359662904357290033429526059563073813232862794349076323382988075319525101901")

  REALEARRAY = REALE.to_s.scan(/\d/)

  def e_to_digits(number)
    @earray = to_array(number)
    REALEARRAY.each_index do |index|
      if REALEARRAY[index] != @earray[index]
        return index
      end
    end
  end

  def digits_to_e(number)
    REALEARRAY.first(number).join(' ')
  end

  def next_digit(number)
    REALEARRAY[number]
  end

  def to_array(longnum)
    longnum.to_s.scan(/\d/)
  end

  def e_days_to_next_test
    numdays = (@e.next_test - Time.now) / (24 * 60 * 60)
    numdays.truncate
  end
end
