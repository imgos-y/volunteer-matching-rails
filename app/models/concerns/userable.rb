module Userable
  extend ActiveSupport::Concern

  included do
    has_one :user, as: :userable
    accepts_nested_attributes_for :user, update_only: true

    delegate :email_address, to: :user
  end
end
