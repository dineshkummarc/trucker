require File.expand_path(File.dirname(__FILE__) + '/../trucker')
require 'test/unit'

gem 'factory_girl', '1.2.3'
require 'factory_girl'

gem 'rack-test', '0.5.3'
require 'rack/test'

gem 'leftright', '0.0.3'
require 'leftright'

gem 'json', '1.2'
require 'json'

set :environment, :test

class Test::Unit::TestCase
  include Rack::Test::Methods

  def self.test(name, &block)
    test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
    defined = instance_method(test_name) rescue false
    raise "#{test_name} is already defined in #{self}" if defined
    if block_given?
      define_method(test_name, &block)
    else
      define_method(test_name) do
        flunk "No implementation provided for #{name}"
      end
    end
  end

  def assert_difference(expression, difference = 1, message = nil, &block)
    b = block.send(:binding)
    exps = Array.wrap(expression)
    before = exps.map { |e| eval(e, b) }

    yield

    exps.each_with_index do |e, i|
      error = "#{e.inspect} didn't change by #{difference}"
      error = "#{message}.\n#{error}" if message
      assert_equal(before[i] + difference, eval(e, b), error)
    end
  end

  def assert_no_difference(expression, message = nil, &block)
    assert_difference expression, 0, message, &block
  end

  def app
    Sinatra::Application
  end

  def body
    last_response.body
  end
  
  def json_body
    JSON.parse(body)
  end

end