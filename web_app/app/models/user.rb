class User < ApplicationRecord

has_many :sessions, dependent: :destroy

before_save :set_password_salt
validates :username, presence: true, uniqueness: true
validates :email, presence: true
validates :password, :length => { :minimum => 6 }



def create params
  user = User.create(user_parameters(params))
  message = {message: 'user created successfully'}
  return [true, message]
end

def index
end

def validate_credentials params
  return [false, {message: 'Account not verified'}] unless self.verified
  #return [false, {message: 'Maximum attempt reached'}] if self.failure_count > 3

  encrpyt_pass = encrypt_password params[:password], self.password_salt
  if encrpyt_pass == self.password
    return true, {message: 'Valid credentials'}
  else
    self.failure_count += 1
    self.save
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
