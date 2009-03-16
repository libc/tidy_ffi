require File.join(File.dirname(__FILE__), 'test_helper')

class TestOptions < Test::Unit::TestCase
  T = TidyFFI::Tidy
  context "public interface" do
    [:default_options, :default_options=, :with_options, :validate_options].each do |method|
      it "responds to #{method}" do
        T.respond_to?(method)
      end
    end
  end

  context "default_options method" do
    before :each do
      T.default_options.clear!
      T.validate_options = false
    end

    context "equals version" do
      it "passes arguments to default_options.merge_with_options" do
        T.default_options.expects(:merge_with_options)
        T.default_options = {:test => 1, :test2 => 2}
      end

      it "merges options with existing" do
        T.default_options = {:test => 1, :test2 => 2}
        T.default_options = {:test3 => 3, :test2 => 42}
        T.default_options.should == {:test => 1, :test2 => 42, :test3 => 3}
      end
    end

    it "has clear! method to clear anything" do
      T.default_options.test = 1
      T.default_options.clear!
      T.default_options.test.should == nil
    end

    it "saves options" do
      T.default_options.option = 1
      T.default_options.option.should == 1
    end

    it "sets optons after creation" do
      T.new('test').options.option.should == nil
      T.default_options.option = 1
      T.new('test').options.option.should == 1
    end
  end

  context "options method" do
    before :each do
      T.validate_options = false
      T.default_options.clear!
      @t = T.new('test')
    end

    context "equal version" do
      before :each do
        @t.options.clear!
      end

      it "passes arguments to options.merge_with_options" do
        @t.options.expects(:merge_with_options)
        @t.options = {:test => 1, :test2 => 2}
      end

      it "merges options with existing" do
        @t.options = {:test => 1, :test2 => 2}
        @t.options = {:test3 => 3, :test2 => 42}
        @t.options.should == {:test => 1, :test2 => 42, :test3 => 3}
      end
    end

    context "clear! method" do
      it "clears options' options" do
        @t.options.test = 1
        @t.options.clear!
        @t.options.test.should == nil
      end

      it "clears default_options's options" do
        T.default_options.test = 1
        @t = T.new('test')
        @t.options.clear!
        @t.options.test.should == nil
      end

      it "clears with_options's options" do
        @t = T.with_options(:test => 1).new('test')
        @t.options.clear!
        @t.options.test.should == nil
      end
    end

    it "saves options" do
      @t.options.option = 1
      @t.options.option.should == 1
    end

    it "passes options to libtidy" do
      @t.options.show_body_only = 1
      @t.clean.should == "test\n"
    end

    it "passes options to clean class method" do
      T.with_options(:show_body_only => true).clean("test").should == "test\n"
    end
  end

  context "with_options proxy class" do
    before :each do
      T.validate_options = false
    end

    it "has options method" do
      T.with_options(:test => 1).options.test.should == 1
    end

    it "has clear! method" do
      T.with_options(:test => 1).clear!.options.test.should == nil
    end

    it "chain methods" do
      proxy = T.with_options(:test => 1).with_options(:test2 => 2)
      proxy.options.test.should == 1
      proxy.options.test2.should == 2
    end

    it "passes options to object" do
      T.with_options(:test => 1).new('test').options.test.should == 1
    end
  end
end