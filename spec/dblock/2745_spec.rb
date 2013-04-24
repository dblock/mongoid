require 'spec_helper'

module Test_2745
  class Sandwich
    include Mongoid::Document
    embeds_many :slices
  end

  class Slice
    include Mongoid::Document
    field :position, default: 0
    embedded_in :sandwiches
  end
end

describe Mongoid do
  it "2745" do
    sandwich = Test_2745::Sandwich.create!
    slice1 = Test_2745::Slice.new
    slice2 = Test_2745::Slice.new
    sandwich.slices << slice1
    sandwich.slices << slice2
    sandwich.collection.where({ _id: sandwich.id }).update({
      "$pull" => { "slices" => { _id: slice1.id } }
    })
    # sandwich.reload.slices.count.should == 1
    # Moped.logger = Logger.new(STDOUT)
    # Moped.logger.level = Logger::DEBUG
    slice2.inc({ position: 5 })
    sandwich.reload.slices.count.should == 1
    sandwich.slices.first.position.should == 5
  end
end
