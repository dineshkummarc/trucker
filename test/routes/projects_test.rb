require 'test_helper'

class ProjectsTest < Test::Unit::TestCase
  def setup
    MongoMapper.database.collections.map(&:remove)
  end

  test 'GET /p.js' do
    p1 = Factory(:project)
    p2 = Factory(:project)

    get '/p.js'
    content = json_body['html']['#content']

    assert_match /id="project_#{p1.id}"/, content
    assert_match /id="project_#{p2.id}"/, content
  end

  test 'GET /p/:id.js' do
    p = Factory(:project)
    get "/p/#{p.id}.js"
    assert_match /#{p.title}/, json_body['html']['#content']
  end

  test 'POST /p (valid)' do
    assert_difference 'Project.count' do
      post '/p', :project => Factory.attributes_for(:project, :title => 'Harmony')
      assert_match /Harmony/, json_body['append']['#projects']
    end
  end

  test 'POST /p (invalid)' do
    assert_no_difference 'Project.count' do
      post '/p', :project => {:title => ''}
      assert json_body['errors'].include?("Title can't be empty")
    end
  end

  test 'DELETE /p/:id' do
    p = Factory(:project)
    assert_difference 'Project.count', -1 do
      delete "/p/#{p.id}"
      assert ["#project_#{p.id}"], json_body['remove']
    end
  end
end