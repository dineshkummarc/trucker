Factory.define(:project) do |f|
  f.sequence(:title) { |n| "Project #{n}" }
end