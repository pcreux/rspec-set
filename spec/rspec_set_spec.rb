require 'spec_helper'

describe 'including Set' do
  it 'adds the ::set method to RSpec::Core::ExampleGroup' do
    expect(RSpec::Core::ExampleGroup).to respond_to(:set)
  end
end

describe 'without an ActiveRecord model' do
  setup_for_error_checking(NonActiveRecordClass)

  it "warns the user that Set only works with AR models" do
    $stderr.rewind
    expect($stderr.string.chomp).to eq(
      "my_object is a NonActiveRecordClass - rspec-set works with ActiveRecord models only"
    )
  end
end

describe 'with an ActiveRecord model' do
  setup_for_error_checking(ActiveRecordClassExample)

  it "doesn't give a warning to the user" do
    $stderr.rewind
    expect($stderr.string.chomp).to be_empty
  end

  it 'creates a method based on the argument to ::set' do
    expect(self).to respond_to(:my_object)
  end
end

describe 'with a destroyed ActiveRecord model' do
  set(:my_destroyed_object) do
    ActiveRecordClassExample.create(name: 'Alfred', age: 77)
  end

  it 'allows us to destroy a model' do
    my_destroyed_object.destroy
    expect(
      ActiveRecordClassExample.find_by(id: my_destroyed_object.id)
    ).to be_nil
  end

  it 'reloads a destroyed model' do
    expect(my_destroyed_object.reload.name).to eq('Alfred')
  end
end

describe 'with a stale model' do
  set(:my_stale_object) do
    ActiveRecordClassExample.create(name: 'Old Name', age: 18)
  end

  it 'allows us to play with the model' do
    my_stale_object.update(name: 'New Name')
    expect(ActiveRecordClassExample.find(my_stale_object.id).name).to eq(
      'New Name'
    )
  end

  it 'reloads the stale model' do
    expect(my_stale_object.name).to eq('Old Name')
  end
end


describe ActiveRecordClassExample do
  set(:ar_class_example) { ActiveRecordClassExample.create(name: 'ex_1') }

  subject { ar_class_example }

  context "when name is changed to 'ex_2" do
    before do
      ar_class_example.update(name: 'ex_2')
    end

    it 'updates the name' do
      expect(subject.name).to eq('ex_2')
    end
  end

  context "when name is 'ex_1" do
    it 'reloads the original name' do
      expect(subject.name).to eq('ex_1')
    end
  end
end

describe 'sub sub contexts' do
  set(:ar_class_example) { ActiveRecordClassExample.create(name: 'apple') }

  subject { ar_class_example }

  context "when name is changed to 'banana'" do
    before do
      ar_class_example.update(name: 'banana')
    end

    it 'updates the name' do
      expect(subject.name).to eq('banana')
    end

    context "when we append ' is good'" do
      before do
        ar_class_example.name << ' is good'
        ar_class_example.save
      end

      it 'updates the appended name' do
        expect(subject.name).to eq('banana is good')
      end
    end

    context "when we append ' is bad'" do
      before do
        ar_class_example.name << ' is bad'
        ar_class_example.save
      end

      it 'also updates the appended name' do
        expect(subject.name).to eq('banana is bad')
      end

      context "when we append ' for you'" do
        before do
          ar_class_example.name << ' for you'
          ar_class_example.save
        end

        it 'contains the full sentence' do
          expect(subject.name).to eq('banana is bad for you')
        end
      end
    end
  end

  context "when name is 'apple'" do
    it 'reloads the original name' do
      expect(subject.name).to eq('apple')
    end
  end
end

describe 'deleting an object' do
  set(:ar_class_example) { ActiveRecordClassExample.create(name: 'apple') }

  subject { ar_class_example }

  context "when I destroy the ar_class_example" do
    before do
      ar_class_example.destroy
    end

    it "is destroyed" do
      expect(ActiveRecordClassExample.find_by_id(ar_class_example.id)).to be_nil
    end
  end

  context "when name is 'apple'" do
    it 'is reloaded from the database' do
      expect(subject.name).to eq('apple')
    end
  end
end
