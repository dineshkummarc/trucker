require 'test_helper'

class StoriesTest < Test::Unit::TestCase
  test 'POST /p/:project_id/s (valid)' do
    p = Factory(:project)
    
    assert_difference 'p.stories.count' do
      post "/p/#{p.id}/s", :story => Factory.attributes_for(:story, :body => 'Do stuff')
    end
    assert last_response.ok?
    assert_match /Do stuff/, json_body['append']['#stories']
  end
  
  test 'POST /p/:project_id/s (invalid)' do
    p = Factory(:project)
    
    assert_no_difference 'p.stories.count' do
      post "/p/#{p.id}/s", :story => {:body => ''}
    end
    assert last_response.ok?
    assert json_body['errors'].include?("Body can't be empty")
  end
end