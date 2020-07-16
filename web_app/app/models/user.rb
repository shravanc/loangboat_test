class User < ApplicationRecord
  has_many :sessions, dependent: :destroy

  before_save :set_password_salt
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true
  validates :password, length: { minimum: 6 }

  def validate_credentials(params)
    encrpyt_pass = encrypt_password params[:password], password_salt
    if encrpyt_pass == password
      [true, { message: 'Valid credentials' }]
    else
      self.failure_count += 1
      save
      [false, { message: 'Invalid credentials' }]
    end
  end

  private

  def set_password_salt
    return unless password_changed?

    self.password_salt = BCrypt::Engine.generate_salt
    self.password = encrypt_password(password, password_salt)
  end

  def encrypt_password(password, password_salt)
    BCrypt::Engine.hash_secret(password, password_salt)
  end
end
