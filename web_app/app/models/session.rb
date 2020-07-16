class Session < ApplicationRecord
  belongs_to :user
  before_save :reset_failed_count

  private

  # On sucessful Login, failure_count is reset to 0 if the valuse is non zero number
  def reset_failed_count
    user = self.user
    user.update_attributes({ failure_count: 0 }) if user.failure_count != 0
  end
end
