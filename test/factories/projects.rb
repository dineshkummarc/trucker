Factory.define(:project) do |f|
  f.sequence(:title) { |n| "Project #{n}" }
end

Factory.define(:story) do |f|
  f.body        "Get some stuff done!"
  f.project_id  { |d| Project.first.try(:id) || Factory(:project).id }
end