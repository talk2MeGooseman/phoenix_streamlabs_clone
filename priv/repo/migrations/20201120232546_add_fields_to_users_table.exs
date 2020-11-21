defmodule PhoenixStreamlabsClone.Repo.Migrations.AddFieldsToUsersTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :email,            :string
      add :uid,              :string
      add :description,      :text
      add :profile_image_url, :string
    end

    create index("users", [:email])
    create index("users", [:uid])
  end
end
