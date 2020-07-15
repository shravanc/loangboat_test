class User < ApplicationRecord

has_many :sessions

before_save :set_password_salt
validates :username, uniqueness: true


def create params
  user = User.create(user_parameters(params))
  message = {message: 'user created successfully'}
  return [true, message]
end

def index
end

def destroy
end

def validate_credentials params
  return [false, {message: 'Account not verified'}] unless self.verified
  logger.warn params
  logger.warn self.inspect
  encrpyt_pass = encrypt_password params[:password], self.password_salt
  if encrpyt_pass == self.password
    return true, {message: 'Valid credentials'}
  else
    return false, {message: 'Invalid credentials'}
  end
end

private


def set_password_salt
  return unless self.password_changed?
  self.password_salt = BCrypt::Engine.generate_salt
  self.password = encrypt_password(self.password, self.password_salt)
end

def encrypt_password password, password_salt
  BCrypt::Engine.hash_secret(password, password_salt)
end

def user_parameters(params)
    params.require(:user).permit([:username, :firstname, :lastname, :email, :mobile_number, :password])
end



end
