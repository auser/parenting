require File.dirname(__FILE__) + '/test_helper.rb'

class Quickie < Parenting::Base
end

class QuickieTest < Test::Unit::TestCase
  context "setting" do
    before do
      @a = Quickie.new do
        @@b = Quickie.new do
          my_name "bob"
          @@c = Quickie.new do
            my_name "frank"
          end
        end
      end
    end
    it "should set the parents properly" do
      @@c.parent.should == @@b
      @@b.parent.should == @a
      @a.parent.should == nil
    end
    it "should set my_name on @@c to frank" do
      @@c.my_name.should == "frank"
    end
    it "should set my_name on @@b to bob" do
      @@b.my_name.should == "bob"
    end
    it "should not set my_name to is_frank on @a" do
      @a.my_name.should == nil
    end
  end
end