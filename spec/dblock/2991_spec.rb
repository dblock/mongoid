require 'spec_helper'

class Chicken
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessor :egg
  after_save :lay_egg

  def lay_egg
    @egg = Egg.create!
  end
end

class Egg
  include Mongoid::Document
  include Mongoid::Timestamps
end


describe "2991" do
  it "creates a timeful chicken and egg" do
    c = Chicken.create!
    c.egg.created_at.should_not be_nil
  end
  it "creates a timeless chicken and a timeful egg" do
    c = Chicken.timeless.create!
    c.created_at.should be_nil
    c.egg.created_at.should_not be_nil
  end
end
