require 'test_helper'

class StoryTest < Test::Unit::TestCase
  should_validate_presence_of :body
  should_belong_to :project
end