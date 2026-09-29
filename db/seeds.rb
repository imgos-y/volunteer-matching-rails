puts "Seeding database..."

# --- Badges ---
bronze = Badge.create!(name: "Bronze Volunteer", required_points: 10, required_event: 1)
silver = Badge.create!(name: "Silver Volunteer", required_points: 30, required_event: 3)
gold = Badge.create!(name: "Gold Volunteer", required_points: 50, required_event: 5)

puts "Created #{Badge.count} badges."

# --- Organizers ---
tom = Organizer.create!(
  email: "Tema@example.com",
  password: "password123",
  name: "Tom",
  surname: "Manager"
)

ayse = Organizer.create!(
  email: "Dostluk@example.com",
  password: "password123",
  name: "Ayşe",
  surname: "Kaya"
)

puts "Created #{Organizer.count} organizers."

# --- Volunteers ---
emir = Volunteer.create!(
  email: "aksoy@example.com",
  password: "password123",
  name: "Emir",
  surname: "Aksoy",
  skill: "First Aid",
  interest: "Health"
)

imge = Volunteer.create!(
  email: "imge@example.com",
  password: "password123",
  name: "Imge",
  surname: "Yüksel",
  skill: "Photography",
  interest: "Arts"
)

deniz = Volunteer.create!(
  email: "deniz@example.com",
  password: "password123",
  name: "Deniz",
  surname: "Koç",
  skill: "Teaching",
  interest: "Education"
)

puts "Created #{Volunteer.count} volunteers."

# --- Events ---
event1 = tom.events.create!(
  name: "Community Health Day",
  description: "A day of free health checkups and first aid awareness for the community.",
  event_date: 1.week.from_now,
  capacity: 5,
  skill_needed: "First Aid",
  interest_needed: "Health"
)

event2 = tom.events.create!(
  name: "Photo Walk in Alsancak",
  description: "Explore İzmir's streets and capture the city's culture through photography.",
  event_date: 2.weeks.from_now,
  capacity: 3,
  skill_needed: "Photography",
  interest_needed: "Arts"
)

event3 = ayse.events.create!(
  name: "After-School Tutoring",
  description: "Help local children with their homework and learning.",
  event_date: 10.days.from_now,
  capacity: 4,
  skill_needed: "Teaching",
  interest_needed: "Education"
)

event4 = ayse.events.create!(
  name: "Beach Cleanup",
  description: "Join us to clean the İzmir coastline and protect marine life.",
  event_date: 3.weeks.from_now,
  capacity: 8,
  skill_needed: "Organization",
  interest_needed: "Environment"
)

puts "Created #{Event.count} events."

# --- Registrations ---
emir.event_registrations.create!(event: event1, status: "registered", registered_at: Time.current)
imge.event_registrations.create!(event: event2, status: "registered", registered_at: Time.current)
deniz.event_registrations.create!(event: event3, status: "registered", registered_at: Time.current)

puts "Created #{EventRegistration.count} registrations."

puts "Seeding complete!"