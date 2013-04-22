require "spec_helper"

describe Mongoid::Extensions::FalseClass do

  describe "#__sortable__" do

    it "returns 0" do
      expect(false.__sortable__).to eq(0)
    end
  end

  describe "#is_a?" do

    context "when provided a Boolean" do

      it "returns true" do
        expect(false.is_a?(Boolean)).to be_true
      end
    end

    context "when provided a FalseClass" do

      it "returns true" do
        expect(false.is_a?(FalseClass)).to be_true
      end
    end

    context "when provided a TrueClass" do

      it "returns false" do
        expect(false.is_a?(TrueClass)).to be_false
      end
    end

    context "when provided an invalid class" do

      it "returns false" do
        expect(false.is_a?(String)).to be_false
      end
    end
  end
end
