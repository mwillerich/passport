require 'active_record'

class AccessToken < ActiveRecord::Base
  belongs_to :user, :polymorphic => true
end
