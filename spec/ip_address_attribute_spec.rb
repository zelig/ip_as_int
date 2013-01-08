require 'spec_helper'
require 'ip_as_int'
require 'active_model'

describe ::IpAsInt::IpAddressAttribute do

  def model
    @model
  end

  shared_examples_for "accessors and validation" do

       context "with validation" do
      before :each do
        @model = model_class(:ip).new
      end

      it "defines attribute writer for ip_address, stores value as integer" do
        model.ip = '192.168.0.1'
        model.read_attribute(:ip).should == 3232235521
      end

      it "defines attribute reader for ip_address, converts value from integer" do
        model.write_attribute(:ip, 3232235521)
        model.ip.should == '192.168.0.1'
        model.should be_valid
      end

      it "nil preserved" do
        model.ip = nil
        model.read_attribute(:ip).should == nil
      end

      it "invalid input preserved" do
        model.ip = "invalid"
        model.read_attribute(:ip).should == nil
        model.ip.should == "invalid"
      end

      it "validates correctly" do
        model.ip = "invalid"
        model.should_not be_valid
      end

      it "validates correctly even if underlying change" do
        model.ip = "invalid"
        model.write_attribute(:ip, 3232235521)
        model.should_not be_valid
      end

      it "invalid on nil IP" do
        model.ip = nil
        model.should_not be_valid
      end

    end

    context "without validation" do
      before :each do
        @model = model_class(:ip, :validation => false).new
      end

      it "valid on invalid IP" do
        model.ip = "invalid"
        model.should be_valid
      end

      it "valid on valid IP" do
        model.ip = '192.168.0.1'
        model.should be_valid
      end

    end
    context "with validation with arguments" do

      before :each do
        @model = model_class(:ip, :validation => { :allow_nil => true }).new
      end

      it "invalid on invalid IP" do
        model.ip = "invalid"
        model.should_not be_valid
      end

      it "valid on valid IP" do
        model.ip = '192.168.0.1'
        model.should be_valid
      end

      it "valid on nil IP" do
        model.ip = nil
        model.should be_valid
      end

    end
  end

  context "activemodel integration" do

    def model_class(*attrs)
      Class.new do
        include ActiveModel::Validations
        include ::IpAsInt::IpAddressAttribute
        ip_address(*attrs)
      end
    end

    include_examples "accessors and validation"

  end

  context "activemodel integration" do

    def model_class(*attrs)
      Class.new(ActiveRecord::Base) do
        include ::IpAsInt::IpAddressAttribute
        ip_address(*attrs)
      end
    end

    include_examples "accessors and validation"

  end


end