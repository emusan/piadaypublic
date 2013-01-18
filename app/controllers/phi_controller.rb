class PhiController < ApplicationController
  before_filter :get_phi,only: [:edit,:update]
  before_filter :signed_in_user
  before_filter :confirmed_user

  include PhiHelper

  def new
  end

  def create
    @phi = Phi.new
    if !test_length(params[:phi])
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of phi, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif
      @phi.digits_known = phi_to_digits(params[:phi])
      @phi.next_test = current_user.test_frequency.days.from_now
      if (@phi.digits_known > 0)
        current_user.phi = @phi
        current_user.phi.save!
        flash[:success] = "You know " + @phi.digits_known.to_s + " digits of phi!"
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
    if(params.has_key?(:phi) && test_length(params[:phi]))             # Must be a test!
      if temp = phi_to_digits(params[:phi])
        if temp >= @phi.digits_known      # Test success!
          @phi.digits_known = temp
          @phi.next_test = current_user.test_frequency.days.from_now
          @phi.save!
          flash[:success] = "You passed! You now know " + @phi.digits_known.to_s + " digits of phi!"
          redirect_to root_path
        elsif params[:reset]              # Reset digits
          @phi.digits_known = temp
          @phi.next_test = current_user.test_frequency.days.from_now
          @phi.save!
          flash[:success] = "You now know " + @phi.digits_known.to_s + " digits of phi!"
          redirect_to root_path
        elsif params[:skip]               # Skip test
          @phi.next_test = current_user.test_frequency.days.from_now
          @phi.save!
          flash[:success] = "Test skipped!(be sure to do your next one though!)"
          redirect_to edit_phi_path(@phi)
        else                              # Test failure!
          flash[:error] = "You seem to have entered something incorrectly or forgetten some digits of phi!, please try again,
                         or click \"Skip Test\" "
          redirect_to edit_phi_path(@phi)
        end
      else                                # Test gone wrong :O
        flash[:error] = "You entered something wrong, remember to begin with 3.14..."
        redirect_to edit_phi_path(@phi)
      end
    elsif(!test_length(params[:phi]))
      flash[:error] = "Sorry, the site currently only supports up to 200 digits of phi, please send an email to me asking for more and I'll update it as soon as I can"
      redirect_to root_path
    elsif(params[:test?])                 # Not a test, but check if they want a test now
      @phi.next_test = Time.now
      @phi.save!
      redirect_to edit_phi_path(@phi)
    else                                  # Not a test, don't want one either
      @phi.digits_known += 1
      @phi.save!
      flash[:success] = "You now know " + @phi.digits_known.to_s + " digits of phi!"
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

  def get_phi
    @phi = current_user.phi
  end
end
