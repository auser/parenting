module Parenting
  class Base
    def context_stack
      $context_stack ||= []
    end
    def initialize(&block)
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
      @depth ||= context_stack.size - 1
    end
  end
end