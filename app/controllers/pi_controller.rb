class PiController < ApplicationController
  before_filter :get_pi,only: [:edit,:update]
  before_filter :signed_in_user
  before_filter :confirmed_user

  include PiHelper

  def new
  end

  def create
    @pi = Pi.new
    if !test_length(params[:pi])
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of pi, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif test_length(params[:pi])
      @pi.digits_known = pi_to_digits(params[:pi])
      @pi.next_test = current_user.test_frequency.days.from_now
      if (@pi.digits_known > 0)
        current_user.pi = @pi
        @pi.save!
        flash[:success] = "You know " + @pi.digits_known.to_s + " digits of pi!"
        redirect_to root_path
      else
        flash[:error] = "You typed that incorrectly."
        render 'new'
      end
    end
  end

  def edit
    render action: 'learn'
  end

  def update
    if(params.has_key?(:pi) && test_length(params[:pi]))              # Must be a test!
      if temp = pi_to_digits(params[:pi])
        if temp >= @pi.digits_known       # Test success!
          @pi.digits_known = temp
          @pi.next_test = current_user.test_frequency.days.from_now
          @pi.save!
          flash[:success] = "You passed! You now know " + @pi.digits_known.to_s + " digits of pi!"
          redirect_to root_path
        elsif params[:reset]              # Reset digits
          @pi.digits_known = temp
          @pi.next_test = current_user.test_frequency.days.from_now
          @pi.save!
          flash[:success] = "You now know " + @pi.digits_known.to_s + " digits of pi!"
          redirect_to root_path
        elsif params[:skip]               # Skip test
          @pi.next_test = current_user.test_frequency.days.from_now
          @pi.save!
          flash[:success] = "Test skipped!(be sure to do your next one though!)"
          redirect_to edit_pi_path(@pi)
        else                              # Test failure!
          flash[:error] = "You seem to have entered something incorrectly or forgetten some digits of pi!, please try again,
                         or reset how many digits you know"
                         redirect_to edit_pi_path(@pi)
        end
      else                                # Test gone wrong
        flash[:error] = "You entered something wrong, remember to begin with 3.14..."
        redirect_to edit_pi_path(@pi)
      end
    elsif(!test_length(params[:pi]))
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of pi, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif(params[:test?])                 # Not a test, but check if they want a test now
      @pi.next_test = Time.now
      @pi.save!
      redirect_to edit_pi_path(@pi)
    else                                  # Not a test, don't want one either
      @pi.digits_known += 1
      @pi.save!
      flash[:success] = "You now know " + @pi.digits_known.to_s + " digits of pi!"
      redirect_to root_path
    end
  end

  private

  def test_length(number)
    if number.to_s.length > 200
      return false
    else
      return true
    end
  end

  def get_pi
    @pi = current_user.pi
  end
end
