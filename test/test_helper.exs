ExUnit.start

Mix.Task.run "ecto.create", ~w(-r MosquitoIdentifier.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r MosquitoIdentifier.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(MosquitoIdentifier.Repo)

