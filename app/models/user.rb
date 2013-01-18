class User < ActiveRecord::Base
  attr_accessible :email,:name,:password,:password_confirmation,:test_frequency,:use_tau
  has_secure_password     # uses the rails built in password stuff, should be quite secure

  before_save { self.email.downcase! }
  before_create { generate_token(:remember_token) }

  validates :name,presence: true,length: {maximum: 40 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,presence: true,format: {with: VALID_EMAIL_REGEX },
                                  uniqueness: { case_sensitive: false }
  validates :password,length: { minimum: 6 },on: :create
  validates :password_confirmation,presence: true,on: :create

  has_one :pi
  has_one :e
  has_one :phi

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def send_email_confirmation
    generate_token(:email_confirmation_token)
    self.email_confirmation_sent_at = Time.zone.now
    save!
    UserMailer.email_confirmation(self).deliver
  end

  def reset_email_confirmed
    self.email_confirmed = false
    self.send_email_confirmation
  end

  def set_confirmed
    self.email_confirmed = true
    self.email_confirmation_token = nil
    self.email_confirmation_sent_at = nil
    self.save!
  end

  def confirmed?
    self.email_confirmed
  end

  private

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
