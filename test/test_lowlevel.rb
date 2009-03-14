require File.join(File.dirname(__FILE__), 'test_helper')

class TestSimple < Test::Unit::TestCase
  I = TidyFFI::Interface
  context "TidyFFI::Interface" do
    context "default_options" do
      it "returns a hash" do
        I.default_options.is_a?(Hash)
      end
      
      it "has show force_output option" do
        I.default_options[:force_output][:name].should == :force_output
        I.default_options[:force_output][:type].should == :boolean
      end
    end
    
    context "option_valid" do
      it "returns false when unknown options is specified" do
        I.option_valid?(:gobbledygook, '1').should == false
      end

      it "accepts yes, no, 1, 0, true, false as boolean values" do
        stub(I).default_options { {:gobbledygook => {:type => :boolean}} }

        %w{yes no 1 0 true false on off YeS}.each do |val|
          I.option_valid?(:gobbledygook, val).should == true
        end
        I.option_valid?(:gobbledygook, 1).should == true
        I.option_valid?(:gobbledygook, 0).should == true
        I.option_valid?(:gobbledygook, true).should == true
        I.option_valid?(:gobbledygook, false).should == true

        I.option_valid?(:gobbledygook, "gobbledygook").should == false
      end

      it "accepts a number as a valid integer value" do
        stub(I).default_options { {:gobbledygook => {:type => :integer}} }

        I.option_valid?(:gobbledygook, 1).should == true
        I.option_valid?(:gobbledygook, 0).should == true
        I.option_valid?(:gobbledygook, "0").should == true
        I.option_valid?(:gobbledygook, "1").should == true
        I.option_valid?(:gobbledygook, "42").should == true

        I.option_valid?(:gobbledygook, "gobbledygook").should == false
        I.option_valid?(:gobbledygook, "true").should == false
      end

      it "accepts any string as a valid string value" do
        stub(I).default_options { {:gobbledygook => {:type => :string}} }

        I.option_valid?(:gobbledygook, 1).should == false
        I.option_valid?(:gobbledygook, 0).should == false

        I.option_valid?(:gobbledygook, "0").should == true
        I.option_valid?(:gobbledygook, "1").should == true
        I.option_valid?(:gobbledygook, "42").should == true
        I.option_valid?(:gobbledygook, "gobbledygook").should == true
        I.option_valid?(:gobbledygook, "true").should == true
        
      end

      it "accepts a symbols as a valid string value" do
        stub(I).default_options { {:gobbledygook => {:type => :string}} }

        I.option_valid?(:gobbledygook, :test).should == true
      end

      it "accepts number in range as a valid enum value" do
        stub(I).default_options { {:gobbledygook => {:type => :enum, :values => ["one", "two"]}} }

        I.option_valid?(:gobbledygook, 1).should == true
        I.option_valid?(:gobbledygook, 0).should == true
        I.option_valid?(:gobbledygook, 3).should == false
      end

      it "accepts string representation of enum value" do
        stub(I).default_options { {:gobbledygook => {:type => :enum, :values => ["one", "two"]}} }

        I.option_valid?(:gobbledygook, "one").should == true
        I.option_valid?(:gobbledygook, "two").should == true
        I.option_valid?(:gobbledygook, "three").should == false
      end
    end
  end
end