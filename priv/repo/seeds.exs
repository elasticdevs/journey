# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Journey.Repo.insert!(%Journey.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Journey.Repo.insert!(%Journey.Prospects.Client{
  name: "Generic",
  client_uuid: "61dfe77c-7afe-11ee-b962-0242ac120002",
  external_id: "NONE",
  status: "ACTIVE"
})
