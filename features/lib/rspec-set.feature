Feature: set

  As a rails developer willing to speed-up my integration tests
  In order to take advantage of examples running in transactions
  I want to use #set that store the data before all example and
  reload active record objects before each examples

  Scenario: Examples run in transactions (no side effects between examples)
    Given a file named "spec/models/widget_spec.rb" with:
      """
      require "spec_helper"

      describe Widget do
        set(:widget) { Widget.create!(:name => 'widget_1') }

        subject { widget }

        context "when name is changed to 'widget_2" do
          before do
            widget.update_attributes!(:name => 'widget_2')
          end

          its(:name) { should == 'widget_2' }
        end

        context "when name is 'widget_1" do
          its(:name) { should == 'widget_1' }
        end
      end
      """
    When I run "rspec spec/models/widget_spec.rb"
    Then the examples should all pass

  Scenario: We can use sub sub contexts just fine
    Given a file named "spec/models/widget_spec.rb" with:
      """
      require "spec_helper"

      describe Widget do
        set(:widget) { Widget.create(:name => 'apple') }

        subject { widget }

        context "when name is changed to 'banana" do
          before do
            widget.update_attributes!(:name => 'banana')
          end

          its(:name) { should == 'banana' }

          context "when we append ' is good'" do
            before do
              widget.name << ' is good'
              widget.save!
            end

            its(:name) { should == 'banana is good' }
          end

          context "when we append ' is bad'" do
            before do
              widget.name << ' is bad'
              widget.save!
            end

            its(:name) { should == 'banana is bad' }

            context "when we append ' for you'" do
              before do
                widget.name << ' for you'
                widget.save!
              end

              its(:name) { should == 'banana is bad for you' }
            end
          end
        end

        context "when name is 'apple" do
          its(:name) { should == 'apple' }
        end
      end
      """
    When I run "rspec spec/models/widget_spec.rb"
    Then the examples should all pass


  Scenario: I can delete an object, it will be available in the next example.
    Given a file named "spec/models/widget_spec.rb" with:
      """
      require "spec_helper"

      describe Widget do
        set(:widget) { Widget.create(:name => 'apple') }

        subject { widget }

        context "when I destroy the widget" do
          before do
            widget.destroy
          end

          it "should be destroyed" do
            Widget.find_by_id(widget.id).should be_nil
          end
        end

        context "when name is 'apple" do
          its(:name) { should == 'apple' }
        end
      end
      """
    When I run "rspec spec/models/widget_spec.rb"
    Then the examples should all pass

  Scenario: I can update a model in a before block

  Scenario: I can use a set model in another set definition
