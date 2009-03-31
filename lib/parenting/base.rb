module Parenting
  module ClassMethods
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
      # @this_context ||= context_stack.last
      context_stack.last
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
    def this
      @this ||= self
    end
    def method_missing(m,*args,&block)
      if block
        if args.empty?
          super
        else          
          inst = args[0]
          context_stack.push self
          inst.instance_eval(&block)
          context_stack.pop
        end
      else
        if parent && parent != self
          begin
            parent.send(m,*args,&block)
          rescue NoMethodError => e
            super   
          end
        else
          super
        end
      end
    end
  end
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end