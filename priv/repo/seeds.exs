# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
alias Twixir.Repo
alias Twixir.Accounts.User
alias Twixir.Stream.Tweet

wayne = Repo.insert!(%User{email: "wayne.shortergmail.com", first_name: "Wayne", last_name: "Shorter"})
coltrane = Repo.insert!(%User{email: "john.coltrane@gmail.com", first_name: "John", last_name: "Coltrane"})
miles = Repo.insert!(%User{email: "miles.davis@gmail.com", first_name: "Miles", last_name: "Davis"})
ornette = Repo.insert!(%User{email: "ornette.coleman@gmail.com", first_name: "Ornette", last_name: "Coleman"})

Repo.insert!(%Tweet{content: "Hey everyone! I love this new Twixir thing!", user_id: wayne.id})
Repo.insert!(%Tweet{content: "Check me out at Birdland! https://www.youtube.com/watch?v=B1Yvdu3c4-o", user_id: miles.id})
Repo.insert!(%Tweet{content: "Just practicing...", user_id: coltrane.id})
Repo.insert!(%Tweet{content: "How many characters do I get?", user_id: ornette.id})
