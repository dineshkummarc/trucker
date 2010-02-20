require 'test_helper'

class StoryTest < Test::Unit::TestCase
  should_validate_presence_of :body, :project_id
  should_belong_to :project
  
  test "increment position before create" do
    s1 = Factory(:story)
    s2 = Factory(:story)
    s3 = Factory(:story)
    
    assert_equal 1, s1.position
    assert_equal 2, s2.position
    assert_equal 3, s3.position
  end
  
  test 'adjust positions after destroy' do
    s1 = Factory(:story)
    s2 = Factory(:story)
    s3 = Factory(:story)
    
    s2.destroy
    
    assert_equal 1, s1.reload.position
    assert_equal 2, s3.reload.position
  end
end