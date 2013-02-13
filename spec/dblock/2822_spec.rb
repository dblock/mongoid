require 'spec_helper'

module Test_2822
  class Display
    include Mongoid::Document
    embeds_many :tables do
      def flipped
        where(flipped: true).first
      end
    end
  end

  class Table
    include Mongoid::Document
    embedded_in :display
  end
end

describe Mongoid do

  let(:cache) do
    ActiveSupport::Cache::MemoryStore.new
  end

  it "returns flipped tables" do
    display = Test_2822::Display.create!
    flipped_table = Test_2822::Table.new(flipped: true)
    display.tables << flipped_table
    display.tables.flipped.should == flipped_table

    2.times do
      display = cache.fetch "display" do
        display
      end
    end

    display.tables.flipped.should == flipped_table
  end

end
