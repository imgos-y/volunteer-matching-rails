puts "Seeding database..."

# --- Badges ---
Badge.find_or_create_by!(name: "Bronze Volunteer") do |b|
  b.required_points = 10
  b.required_event = 1
end
Badge.find_or_create_by!(name: "Silver Volunteer") do |b|
  b.required_points = 30
  b.required_event = 3
end
Badge.find_or_create_by!(name: "Gold Volunteer") do |b|
  b.required_points = 50
  b.required_event = 5
end

# --- Organizers ---
tom = Organizer.find_or_create_by!(email: "john@example.com") do |o|
  o.password = "password123"
  o.name = "TEMA"
end

ayse = Organizer.find_or_create_by!(email: "dostluk@example.com") do |o|
  o.password = "password123"
  o.name = "LOSEV"
end

# --- Volunteers ---
emir = Volunteer.find_or_create_by!(email: "aksoy@example.com") do |v|
  v.password = "password123"
  v.name = "Emir"
  v.surname = "Aksoy"
  v.skill = "First Aid"
  v.interest = "Health"
end

imge = Volunteer.find_or_create_by!(email: "imge@example.com") do |v|
  v.password = "password123"
  v.name = "Imge"
  v.surname = "Yüksel"
  v.skill = "Photography"
  v.interest = "Arts"
end

deniz = Volunteer.find_or_create_by!(email: "deniz@example.com") do |v|
  v.password = "password123"
  v.name = "Deniz"
  v.surname = "Koç"
  v.skill = "Teaching"
  v.interest = "Education"
end

# --- Events ---
event1 = tom.events.find_or_create_by!(name: "Community Health Day") do |e|
  e.description = "A day of free health checkups and first aid awareness for the community."
  e.event_date = 1.week.from_now
  e.capacity = 5
  e.skill_needed = "First Aid"
  e.interest_needed = "Health"
end

event2 = tom.events.find_or_create_by!(name: "Photo Walk in Alsancak") do |e|
  e.description = "Explore İzmir's streets and capture the city's culture through photography."
  e.event_date = 2.weeks.from_now
  e.capacity = 3
  e.skill_needed = "Photography"
  e.interest_needed = "Arts"
end

event3 = ayse.events.find_or_create_by!(name: "After-School Tutoring") do |e|
  e.description = "Help local children with their homework and learning."
  e.event_date = 10.days.from_now
  e.capacity = 4
  e.skill_needed = "Teaching"
  e.interest_needed = "Education"
end

ayse.events.find_or_create_by!(name: "Beach Cleanup") do |e|
  e.description = "Join us to clean the İzmir coastline and protect marine life."
  e.event_date = 3.weeks.from_now
  e.capacity = 8
  e.skill_needed = "Organization"
  e.interest_needed = "Environment"
end

# --- Registrations ---
[[emir, event1], [imge, event2], [deniz, event3]].each do |volunteer, event|
  EventRegistration.find_or_create_by!(volunteer: volunteer, event: event) do |r|
    r.status = "registered"
    r.registered_at = Time.current
  end
end

puts "Badges: #{Badge.count}, Organizers: #{Organizer.count}, Volunteers: #{Volunteer.count}, " \
       "Events: #{Event.count}, Registrations: #{EventRegistration.count}"
puts "Seeding complete!"