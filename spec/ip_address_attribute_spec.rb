require 'spec_helper'
require 'ip_as_int'
require 'active_model'
require 'active_record'
require 'logger'

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

  context "activerecord integration" do

    ActiveRecord::Base.establish_connection({'adapter' => 'sqlite3', 'database' => ":memory:" })
    ActiveRecord::Base.logger = Logger.new("#{File.dirname(__FILE__)}/../../active_record.log")

    def model_class(*attrs)
      ActiveRecord::Base.connection.create_table(:testmodels, :force=>true) do |t|
        attrs.each do |attr|
          t.integer attr unless attr.is_a?(Hash)
        end
      end
      Class.new(ActiveRecord::Base) do
        self.table_name = 'testmodels'
        include ::IpAsInt::IpAddressAttribute
        ip_address(*attrs)
        def write_attribute(*)
          super
        end
        def read_attribute(*)
          super
        end
      end
    end

    include_examples "accessors and validation"

    context "persistence and scoping" do

      before :each do
        @model_class = model_class(:ip, :validation => { :allow_nil => true })
        @model = @model_class.new
      end

      it "survives persistence in db" do
        model.ip = '192.168.0.1'
        model.save.should be_true
        model.reload.ip.should == '192.168.0.1'
      end

      it "supports scope for retrieval from db by ip strings" do
        models = @model_class.create(
          [{ :ip => '192.168.0.1' },
           { :ip => '192.168.0.2' },
           { :ip => '192.168.0.3' }
           ])
        @model_class.ip('192.168.0.1', '192.168.0.2').should == models[0..1]
      end

    end

  end


end
