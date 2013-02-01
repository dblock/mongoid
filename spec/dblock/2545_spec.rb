require "spec_helper"

module Test_2545
  class Sandwich
    include Mongoid::Document
    embeds_many :slices
  end

  class Slice
    include Mongoid::Document
    field :thickness
    embedded_in :sandwich
  end
end

describe Mongoid do

  it "2545" do
    sandwich = Test_2545::Sandwich.create!
    slice1 = Test_2545::Slice.create!({ sandwich: sandwich, thickness: 1 })
    slice2 = Test_2545::Slice.create!({ sandwich: sandwich, thickness: 2 })

    sandwich.slices.count.should == 2
    sandwich.slices.first.thickness.should == 1
    sandwich.slices.last.thickness.should == 2

    sandwich.collection.where({ _id: sandwich.id }).update({
      "$pull" => { "slices" => { _id: slice1.id }}
    })
    sandwich.collection.find.first.should == {
      "_id" => sandwich.id,
      "slices" => [{ "_id" => slice2.id, "thickness" => slice2.thickness }]
    }

    # => we don't expect mongoid to notice the concurrent removal
    sandwich.slices.count.should == 2

    slice2.update_attributes!({ thickness: 3 })

    # => we do expect mongoid to update the correct record
    sandwich.collection.find.first.should == {
      "_id" => sandwich.id,
      "slices" => [{ "_id" => slice2.id, "thickness" => slice2.thickness }]
    }

  end

end
