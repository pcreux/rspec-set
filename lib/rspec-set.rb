module RSpec
  module Core
    module Set 
      module ClassMethods
        # Set @variable_name in a before(:all) block and give access to it
        # via let(:variable_name)
        #
        # Example:
        #
        #   set(:transaction) { Factory(:address) }
        #
        #   it "should be valid" do
        #     transaction.should be_valid
        #   end
        #
        def set(variable_name, &block)
          before(:all) do
            self.class.send(:class_variable_set, "@@#{variable_name}".to_sym, instance_eval(&block))
          end
         
          let(variable_name) do 
            self.class.send(:class_variable_get, "@@#{variable_name}".to_sym).tap do |i|
              if i.respond_to?(:new_record?) && i.respond_to?(:reload)
                i.reload unless i.new_record?
              end
            end
          end
        end # set()

      end # ClassMethods

      def self.included(mod) # :nodoc:
        mod.extend ClassMethods
      end
    end # Set

    class ExampleGroup
      include Set 
    end # ExampleGroup

  end # Core
end # RSpec
