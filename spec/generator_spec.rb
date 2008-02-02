require File.dirname(__FILE__) + '/spec_helper.rb'

describe Diff::Display::Unified::Generator do
  
  before(:each) do
    @generator = Diff::Display::Unified::Generator.new
  end
  
  it "Generator.run raises if doesn't get a Enumerable object" do
    proc {
      Diff::Display::Unified::Generator.run(nil)
    }.should raise_error(ArgumentError)
  end
  
  it "Generator.run processes each line in the diff" do
    Diff::Display::Unified::Generator.expects(:new).returns(@generator)
    @generator.expects(:process).with("foo")
    @generator.expects(:process).with("bar")
    Diff::Display::Unified::Generator.run("foo\nbar")
  end
  
  it "Generator.run returns the data" do
    Diff::Display::Unified::Generator.expects(:new).returns(@generator)
    @generator.expects(:data).returns("foo")
    generated = Diff::Display::Unified::Generator.run("foo\nbar")
    generated.should == "foo"
  end
  
end
