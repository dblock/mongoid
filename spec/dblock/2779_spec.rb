require 'spec_helper'

module Test_2779
  class Invitation
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user
    before_destroy :destroy_user

    def destroy_user
      self.user.destroy if self.user
    end
  end

  class User
    include Mongoid::Document
    include Mongoid::Timestamps

    has_many :invitations
  end
end

describe Mongoid do
  it "2779" do
    invitation = Test_2779::Invitation.create!
    user = Test_2779::User.create!
    user.invitations << invitation
    invitation.destroy
  end
end