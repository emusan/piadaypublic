class EController < ApplicationController
  before_filter :get_e,only: [:edit,:update]
  before_filter :signed_in_user
  before_filter :confirmed_user

  include EHelper

  def new
  end

  def create
    @e = E.new
    if !test.length(params[:e])
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of e, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif
      @e.digits_known = e_to_digits(params[:e])
      @e.next_test = current_user.test_frequency.days.from_now
      if (@e.digits_known > 0)
        current_user.e = @e
        current_user.e.save!
        flash[:success] = "You know " + @e.digits_known.to_s + " digits of e!"
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
    if(params.has_key?(:e) && test_length(params[:e]))             # Must be a test!
      if temp = e_to_digits(params[:e])
        if temp >= @e.digits_known      # Test success!
          @e.digits_known = temp
          @e.next_test = current_user.test_frequency.days.from_now
          @e.save!
          flash[:success] = "You passed! You now know " + @e.digits_known.to_s + " digits of e!"
          redirect_to root_path
        elsif params[:reset]            # Reset digits
          @e.digits_known = temp
          @e.next_test = current_user.test_frequency.days.from_now
          @e.save!
          flash[:success] = "You now know " + @e.digits_known.to_s + " digits of e!"
          redirect_to root_path
        elsif params[:skip]             # Skip test
          @e.next_test = current_user.test_frequency.days.from_now
          @e.save!
          flash[:success] = "Test skipped!(be sure to do your next one though!)"
          redirect_to edit_e_path(@e)
        else                            # Test failure!
          flash[:error] = "You seem to ahve entered something incorrectly or forgotten some digits of e!, please try again,
                            or click \"Skip Test\" "
                            redirect_to edit_e_path(@e)
        end
      else                              # Test wrong :O(not sure this ever comes up, but here just in case lol
        flash[:error] = "You entered something wrong, please remember to begin with 3.14..."
        redirect_to edit_e_path(@e)
      end
    elsif(!test_length(params[:e]))
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of e, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif(params[:test?])               # Not a test, but check if they want one now
      @e.next_test = Time.now
      @e.save!
      redirect_to edit_e_path(@e)
    else                                # Not a test, don't want one either
      @e.digits_known += 1
      @e.save!
      flash[:success] = "You now know " + @e.digits_known.to_s + " digits of e!"
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

  def get_e
    @e = current_user.e
  end
end
