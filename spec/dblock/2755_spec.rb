require 'spec_helper'

module Test_2755
  class Collection
    include Mongoid::Document
    embeds_many :things
  end

  class Thing
    include Mongoid::Document
    field :index
    field :name
    embedded_in :collection  
  end
end

describe Mongoid do
  it "2755" do
    c =  Test_2755::Collection.create!
    11.times do |i|
      c.things <<  Test_2755::Thing.new(index: i, name: "t#{i}")\
    end
    c.things.where({ :index.gt => 9 }).each do |thing|
      thing.update_attributes!({ index: thing.index - 1 })
    end
    c.reload.things.count.should == 11
  end
end