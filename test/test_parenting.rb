require File.dirname(__FILE__) + '/test_helper.rb'

class Quickie
  include Parenting
  attr_accessor :my_name
  def initialize(nm="Default", &block)
    @my_name ||= nm
    run_in_context(&block) if block
  end
end

class QuickieTest < Test::Unit::TestCase
  context "setting" do
    before do
      @a = Quickie.new do
        $b = Quickie.new("franke") do
          $c = Quickie.new("bob") do
          end
        end
      end
    end
    it "should set the parents properly" do
      $c.parent.should == $b
      $b.parent.should == @a
      @a.parent.should == nil
    end
    it "should have proper depth" do
      @a.depth.should == 0
      $b.depth.should == 1
      $c.depth.should == 2
    end
    it "should have current_context" do
      $context_stack.should == []
      @a.current_context.should == []
      $b.current_context.should ==[@a]
      $c.current_context.should ==[@a, $b]
    end
    it "should set my_name on $c to frank" do
      $c.my_name.should == "bob"
    end
    it "should set my_name on $b to bob" do
      $b.my_name.should == "franke"
    end
    it "should not set my_name to is_frank on @a" do
      @a.my_name.should == "Default"
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
            $d = @d = Quickie.new do
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
    it "should have the latest context set as the last item in the stack" do
      @a.b.c.this_context.nil?.should == false
      @a.b.this_context.should == @a.b
      @a.b.c.this_context.should == @a.b.c
      @a.b.c.d.this_context.should == @a.b.c.d
    end
  end
  context "for a file" do
    before do
      @apple = Quickie.eval_from_file "file_to_eval.rb"
    end
    it "should set the parent's properly" do
      @apple.parent.should == nil
      @apple.b.parent.should == @apple
      @apple.b.c.parent.should == @apple.b
      @apple.b.c.d.parent.should == @apple.b.c
    end
    it "should set the depth" do
      @apple.depth.should == 0
      @apple.b.depth.should == 1
      @apple.b.c.depth.should == 2
      @apple.b.c.d.depth.should == 3
    end
    it "should have a current context" do
      @apple.context_stack.size.should == 0
      @apple.b.current_context.should == [@apple]
      @apple.b.c.current_context.should == [@apple,@apple.b]
      @apple.b.c.d.current_context.should == [@apple, @apple.b, @apple.b.c]
    end
    it "should no be weird" do
      $d.should == @apple.b.c.d
      $d.parent.should == @apple.b.c
      $d.parent.parent.parent.should == @apple
    end
    it "should have the latest context set as the last item in the stack" do
      @apple.b.c.this_context.nil?.should == false
      @apple.b.this_context.should == @apple.b
      @apple.b.c.this_context.should == @apple.b.c
      @apple.b.c.d.this_context.should == @apple.b.c.d
    end
  end
end