require 'spec_helper'

describe 'including Set' do
  it 'adds the ::set method to RSpec::Core::ExampleGroup' do
    expect(RSpec::Core::ExampleGroup).to respond_to(:set)
  end
end

describe 'without an ActiveRecord model' do
  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
  end

  set(:my_object) { NonActiveRecordClass.new }

  after do
    $stderr = @orig_stderr
  end

  it "warns the user that Set only works with AR models" do
    $stderr.rewind
    expect($stderr.string.chomp).to eq(
      "my_object is a NonActiveRecordClass - rspec-set works with ActiveRecord models only"
    )
  end
end

describe 'with an ActiveRecord model' do
  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
  end

  set(:my_ar_object) do
    ActiveRecordClassExample.create!(name: 'Person', age: 25)
  end

  after do
    $stderr = @orig_stderr
  end

  it "doesn't give a warning to the user" do
    $stderr.rewind
    expect($stderr.string.chomp).to be_empty
  end

  it 'creates a method based on the argument to ::set' do
    expect(self).to respond_to(:my_ar_object)
  end
end

describe 'with a destroyed ActiveRecord model' do
  set(:my_destroyed_object) do
    ActiveRecordClassExample.create!(name: 'Alfred', age: 77)
  end

  it 'reloads a destroyed model' do
    my_destroyed_object.destroy
    expect(my_destroyed_object.persisted?).to be_false
  end
end

describe 'with a stale model' do
  set(:my_stale_object) do
    ActiveRecordClassExample.create!(name: 'Old Name', age: 18)
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