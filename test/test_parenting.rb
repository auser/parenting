require File.dirname(__FILE__) + '/test_helper.rb'

class Quickie < Parenting::Base
end

class QuickieTest < Test::Unit::TestCase
  context "setting" do
    before do
      @a = Quickie.new do
        $b = Quickie.new do
          my_name "bob"
          $c = Quickie.new do
            my_name "frank"
          end
        end
      end
    end
    it "should set the parents properly" do
      $c.parent.should == $b
      $b.parent.should == @a
      @a.parent.should == nil
    end
    it "should set my_name on $c to frank" do
      $c.my_name.should == "frank"
    end
    it "should set my_name on $b to bob" do
      $b.my_name.should == "bob"
    end
    it "should not set my_name to is_frank on @a" do
      @a.my_name.should == nil
    end
  end
  context "from within a module_eval" do
    before(:all) do
      @a = Quickie.new
      @a.eval_from_string <<-EOE
      self.class.send :attr_reader, :b
        @b = Quickie.new do
          self.class.send :attr_reader, :c
          @c = Quickie.new do
            self.class.send :attr_reader, :d
            my_name "bob"
            $d = @d = Quickie.new do
              my_name "frank"
            end
          end
        end
      EOE
    end
    it "should set the parent's properly" do
      @a.parent.should == nil
      @a.b.parent.should == @a
      @a.b.c.parent.should == @a.b
      @a.b.c.d.parent.should == @a.b.c
    end
    it "should set the depth" do
      @a.depth.should == 0
      @a.b.depth.should == 1
      @a.b.c.depth.should == 2
      @a.b.c.d.depth.should == 3
    end
    it "should have a current context" do
      @a.context_stack.size.should == 0
      @a.b.current_context.should == [@a]
      @a.b.c.current_context.should == [@a,@a.b]
      @a.b.c.d.current_context.should == [@a, @a.b, @a.b.c]
    end
    it "should no be weird" do
      $d.should == @a.b.c.d
      $d.parent.should == @a.b.c
      $d.parent.parent.parent.should == @a
    end
  end
end