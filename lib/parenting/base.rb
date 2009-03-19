module Parenting
  module ClassMethods
    def default_options(hsh={})
      @default_dsl_options ||= hsh
    end
  end
  
  module InstanceMethods
    def context_stack
      $context_stack ||= []
    end
    def run_in_context(&block)
      @parent = parent

      context_stack.push self
      this_context.instance_eval &block if block
      context_stack.pop
      head   
    end

    def head
      context_stack.first
    end
    def this_context
      @this_context ||= context_stack.last
    end
    def parent
      @parent ||= current_context[-1] == self ? current_context[-2] : current_context[-1]
    end

    def current_context
      @current_context ||= context_stack[0..depth]
    end
    def depth
      @depth ||= context_stack.size
    end
    def eval_from_string(str="")
      instance_eval <<-EOM
        def run_child(pa)
          context_stack.push pa
          this.instance_eval <<-EOE
          #{str}
          EOE
          context_stack.pop
          self
        end
      EOM
      run_child(self)
    end
    def eval_from_file(filename=nil)
      File.open(filename, 'r') do |f|
        eval f.read, binding, __FILE__, __LINE__
      end
    end
    def this
      @this ||= self
    end
    def method_missing(m,*a,&block)
      if block
        if args.empty?
          super
        else          
          inst = a[0]
          context_stack.push self
          inst.instance_eval(&block)
          context_stack.pop
          h[m] = inst          
        end
      else
        super
      end
    end
  end
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end