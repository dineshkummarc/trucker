require 'test_helper'

class IndexTest < Test::Unit::TestCase
  def setup
    MongoMapper.database.collections.map(&:remove)
  end

  test 'GET /' do
    get '/'
    assert last_response.ok?
  end
end