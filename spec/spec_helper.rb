require 'rspec-set'
require 'database_cleaner'
require 'active_record'

require_relative './fixtures/non_active_record_class'
require_relative './fixtures/active_record_class_example'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before(:suite) do
    setup_database
  end

  config.after(:suite) do
    destroy_database
  end
  
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.order = 'random'
end

def db
  ActiveRecord::Base.connection
end

def setup_database
  ActiveRecord::Base.establish_connection(
    :adapter => 'sqlite3',
    :database => 'spec/db/rspec-set-test.sqlite3'
  )

  db.tables.each do |table|
    db.execute("DROP TABLE #{table}")
  end

  Dir[File.join(File.dirname(__FILE__), "db/migrate", "*.rb")].each do |f| 
    require f
    migration = Kernel.const_get(f.split("/").last.split(".rb").first.gsub(/\d+/, "").split("_").collect{|w| w.strip.capitalize}.join())
    migration.migrate(:up)
  end
end

def destroy_database
  db.tables.each do |table|
    db.execute("DROP TABLE #{table}")
  end
end

def setup_for_error_checking(klass)
  before do
    @orig_stderr = $stderr
    $stderr = StringIO.new
  end

  set(:my_object) { klass.create(name: 'Test Name') }

  after do
    $stderr = @orig_stderr
  end
end