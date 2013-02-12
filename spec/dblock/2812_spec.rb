require "spec_helper"

module Test_2812
  class Sandwich
    include Mongoid::Document
    has_and_belongs_to_many :meats
  end

  class Meat
    include Mongoid::Document
    has_and_belongs_to_many :sandwiches
  end
end

describe Mongoid do

  it "2812" do
    # create a meats collection, without it, no error
    Test_2812::Meat.create!

    sandwich = Test_2812::Sandwich.create!
    sandwich.destroy
    sandwich.meats.count.should == 0
  end

end
