require File.join(File.dirname(__FILE__), 'test_helper')

class TestSimple < Test::Unit::TestCase
  T = TidyFFI::Tidy
  context "TidyFFI::Tidy" do
    context "public interface" do
      [[:initialize, -2],
       [:clean, 0]].each do |method, arity|
         it "method #{method} has arity #{arity}" do
           T.instance_method(method).arity.should == arity
         end
       end
    end
    
    context "simple cleanup" do
      it "clean up text" do
        T.new("test").clean.should =~ %r{<body>\s+test\s+</body>}
        T.new("test").clean.should =~ %r{<meta name="generator" content=.+?Tidy.+?>}m
      end
    end
  end
end