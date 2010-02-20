require 'test_helper'

class IndexTest < Test::Unit::TestCase
  test 'GET /' do
    get '/'
    assert last_response.ok?
  end
end