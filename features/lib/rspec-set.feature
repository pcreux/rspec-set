Feature: #set

  Scenario: examples run in transactions
    Given a file named "spec/models/widget_spec.rb" with:
      """
      require "spec_helper"

      describe Widget do
        set(:widget) { Widget.create }

        context "when name is 'widget_1" do
          its(:name) { should == 'widget_1}
        end

        context "when no name given" do
          its(:name) { should be_nil }
        end
      end
      """
    When I run "rspec spec/models/widget_spec.rb"
    Then the examples should all pass
    Then the output should contain all of these:
      | .. |
      | 2 examples |

  Scenario: examples run in transactions
    Given a file named "spec/models/widget_spec.rb" with:
      """
      require "spec_helper"

      describe Widget do
        set(:widget) { Widget.create }

        context "when name is 'widget_1" do
          its(:name) { should == 'widget_1}
        end

        context "when no name given" do
          its(:name) { should be_nil }
        end
      end
      """
    When I run "rspec spec/models/widget_spec.rb"
    Then the examples should all pass

