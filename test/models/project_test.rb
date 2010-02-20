require 'test_helper'

class ProjectTest < Test::Unit::TestCase
  should_validate_presence_of :title
  should_have_many :stories
end