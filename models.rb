module IdentityMapAddition
  def self.included(model)
    model.plugin MongoMapper::Plugins::IdentityMap
  end
end
MongoMapper::Document.append_inclusions(IdentityMapAddition)

class Story
  include MongoMapper::Document
  
  key :body, String, :required => true
  key :project_id, ObjectId, :required => true, :index => true
  key :position, Integer, :default => 1, :protected => true
  
  belongs_to :project
  
  before_create :set_position
  after_destroy :adjust_positions
  
  private
    def set_position
      self.position = project.stories.count + 1
    end
    
    def adjust_positions
      self.class.decrement({:project_id => project_id, :position => {'$gt' => position}}, :position => 1)
    end
end

class Project
  include MongoMapper::Document
  
  key :title, String, :required => true
  many :stories, :dependent => :destroy, :order => :position.asc
end