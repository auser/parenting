module Parenting
  class Base
    
    def context_stack
      $context_stack ||= []
    end
    def run_in_context(&block)
      @parent = parent

      context_stack.push self
      instance_eval &block if block
      context_stack.pop
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
          #{str}
          context_stack.pop
          self
        end
      EOM
      run_child(self)
    end
    def this
      self
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
end