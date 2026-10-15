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

# Hesap varsa onun profilini döndürür, yoksa profil + kullanıcıyı birlikte oluşturur
def seed_account(profile_class, email, **profile_attributes)
  User.find_by(email_address: email)&.userable ||
    profile_class.create!(**profile_attributes, user_attributes: { email_address: email, password: "password123" })
end

# --- Organizers ---
tom = seed_account(Organizer, "john@example.com", name: "TEMA")
ayse = seed_account(Organizer, "dostluk@example.com", name: "LOSEV")

# --- Volunteers ---
emir = seed_account(Volunteer, "aksoy@example.com",
                    name: "Emir", surname: "Aksoy", skill: "First Aid", interest: "Health")
imge = seed_account(Volunteer, "imge@example.com",
                    name: "Imge", surname: "Yüksel", skill: "Photography", interest: "Arts")
deniz = seed_account(Volunteer, "deniz@example.com",
                     name: "Deniz", surname: "Koç", skill: "Teaching", interest: "Education")

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
[ [ emir, event1 ], [ imge, event2 ], [ deniz, event3 ] ].each do |volunteer, event|
  EventRegistration.find_or_create_by!(volunteer: volunteer, event: event) do |r|
    r.status = "registered"
    r.registered_at = Time.current
  end
end

puts "Badges: #{Badge.count}, Users: #{User.count}, Organizers: #{Organizer.count}, Volunteers: #{Volunteer.count}, " \
       "Events: #{Event.count}, Registrations: #{EventRegistration.count}"
puts "Seeding complete!"
