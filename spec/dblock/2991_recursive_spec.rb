require 'spec_helper'

class Chicken
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :egg
  before_save :lay_timeless_egg

  def lay_timeless_egg
    @egg = Egg.timeless.create!
  end
end

class Egg
  include Mongoid::Document
  include Mongoid::Timestamps
end


describe "2991 recursive" do
  it "creates a timeful chicken and a timeless egg" do
    c = Chicken.create!
    c.created_at.should_not be_nil
    c.egg.created_at.should be_nil
  end
  it "creates a timeless chicken and egg" do
    c = Chicken.timeless.create!
    c.created_at.should be_nil
    c.egg.created_at.should be_nil
  end
end
