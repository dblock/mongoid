require 'spec_helper'

module Test_2816
  class Princess
    include Mongoid::Document
    field :primary_color

    def color
      primary_color.to_s
    end

    validates_presence_of :color
  end
end

describe Mongoid do

  it "2816" do
    expect { Test_2816::Princess.create! }.to raise_error Mongoid::Errors::Validations, /Color can't be blank/
  end

end
