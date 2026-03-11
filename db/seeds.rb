# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# 1. Create Default Instructor User
puts "Creating/Updating Instructor..."
User.find_or_create_by!(email: "instructor@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
end
puts "Instructor ready: instructor@example.com / add a"

# 2. Create Sample Lessons
puts "Creating Sample Lessons..."

# Lesson 1: Introduction to Social Wellbeing
lesson1 = Lesson.find_or_create_by!(title: "Introduction to Social Wellbeing")

# Page 1: What is Social Wellbeing?
p1 = Page.find_or_initialize_by(lesson: lesson1, title: "What is Social Wellbeing?")
p1.content = "<div>Social wellbeing is about the sense of belonging and social contribution we feel in our community and relationships. It involves having supportive social networks and feeling connected to others.</div>"
p1.position = 1
p1.save!

# Page 2: The Principles of Relationship
p2 = Page.find_or_initialize_by(lesson: lesson1, title: "The Principles of Relationship")
p2.content = "<div>Building healthy relationships is a core part of social wellbeing. Some key principles include trust, communication, and boundaries.</div>"
p2.position = 2
p2.save!

# Add a Survey to Page 2
if p2.questions.empty?
  puts "Adding Survey to 'The Principles of Relationship'..."
  q1 = p2.questions.create!(text: "Which of these are principles of a healthy relationship?", multiple_answers: true)
  q1.question_options.create!([
    { text: "Honest communication" },
    { text: "Respecting boundaries" },
    { text: "Control over the other person" },
    { text: "Trust and equality" }
  ])
  
  q2 = p2.questions.create!(text: "How are you feeling today about your social connections?", multiple_answers: false)
  q2.question_options.create!([
    { text: "Very connected" },
    { text: "Somewhat connected" },
    { text: "A bit lonely" },
    { text: "Prefer not to say" }
  ])
end

# Lesson 2: Interactive Learning
lesson2 = Lesson.find_or_create_by!(title: "Interactive Learning")

# Page 1: Practice Your Knowledge
p3 = Page.find_or_initialize_by(lesson: lesson2, title: "Practice Your Knowledge")
p3.content = "<div>Test your memory of relationship principles with this interactive game below!</div>"
p3.position = 1
p3.save!

# Add the Memory Match Game to Lesson 2
Game.find_or_create_by!(lesson: lesson2, title: "Social Wellbeing - The Principle of Relationship Game") do |g|
  g.game_type = "memory_match"
end

puts "Seed data successfully loaded!"
