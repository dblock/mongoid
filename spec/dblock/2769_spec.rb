require 'spec_helper'

module Test_2769
  class Sandwich
    include Mongoid::Document
    embeds_many :slices
  end

  class Slice
    include Mongoid::Document
    field :position, default: 0
    embedded_in :sandwiches
    embeds_one :measure
  end

  class Measure
    include Mongoid::Document
    field :thickness
    embedded_in :slice
  end
end

describe Mongoid do
  it "2769" do
    sandwich = Test_2769::Sandwich.create!
    slice1 = Test_2769::Slice.new
    slice2 = Test_2769::Slice.new
    sandwich.slices << slice1
    sandwich.slices << slice2
    sandwich.collection.where({ _id: sandwich.id }).update({ 
      "$pull" => { "slices" => { _id: slice1.id } }
    })
    sandwich.reload.slices.count.should == 1
    # Moped.logger = Logger.new(STDOUT)
    # Moped.logger.level = Logger::DEBUG
    slice2.measure = Test_2769::Measure.new
    sandwich.reload.slices.count.should == 1
  end
end