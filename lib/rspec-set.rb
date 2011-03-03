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
              if i.is_a?(ActiveRecord::Base)
                if i.destroyed?
                  i.class.find(i.id)
                elsif !i.new_record?
                  i.reload
                else
                  i # do nothing
                end
              else
                warn "rspec-set works with ActiveRecord::Base object"
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
