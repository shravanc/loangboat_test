class Session < ApplicationRecord

belongs_to :user
before_save :reset_failed_count



private

def reset_failed_count
  user = self.user
  user.update_attributes({failure_count: 0}) if user.failure_count != 0
end

end
