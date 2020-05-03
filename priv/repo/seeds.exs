# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cookpod.Repo.insert!(%Cookpod.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

changeset = Cookpod.User.changeset(%Cookpod.User{}, %{email: "test@test.ru", password: "test"})
Cookpod.Repo.insert!(changeset)
