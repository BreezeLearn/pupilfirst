after 'development:schools' do
  puts 'Seeding courses (idempotent)'

  grade_labels = {
    1 => 'Not Accepted',
    2 => 'Needs Improvement',
    3 => 'Good',
    4 => 'Great',
    5 => 'Wow'
  }

  sv = School.find_by(name: 'SV.CO')


  Course.create!(name: 'Startup', description: Faker::Lorem.paragraph, max_grade: 5, pass_grade: 2, grade_labels: grade_labels, school: sv)
  Course.create!(name: 'Developer', description: Faker::Lorem.paragraph, max_grade: 5, pass_grade: 2, grade_labels: grade_labels, school: sv)
  Course.create!(name: 'VR', description: Faker::Lorem.paragraph, max_grade: 5, pass_grade: 2, grade_labels: grade_labels, school: sv)
  Course.create!(name: 'iOS', description: Faker::Lorem.paragraph, max_grade: 5, pass_grade: 3, grade_labels: grade_labels, school: sv)
end
