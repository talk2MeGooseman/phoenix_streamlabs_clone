defmodule PhoenixStreamlabsClone.UserManagerTest do
  use PhoenixStreamlabsClone.DataCase

  alias PhoenixStreamlabsClone.UserManager

  describe "users" do
    alias PhoenixStreamlabsClone.UserManager.User

    @valid_attrs %{password: "some password", username: "some username", uid: "someuid", email: "test@email.com", provider: "twitch"}
    @update_attrs %{password: "some updated password", username: "some updated username"}
    @invalid_attrs %{password: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserManager.create_user()

      user
    end

    def auth_info do
      %{
        credentials: %{
          expires: true,
          expires_at: 1605928070,
          other: %{},
          refresh_token: "arefreshtoken",
          scopes: ["user:read:email"],
          secret: nil,
          token: "atokenthing",
          token_type: nil
        },
        extra: %{
          raw_info: %{
            token: %OAuth2.AccessToken{
              access_token: "atokenthing",
              expires_at: 1605928070,
              other_params: %{"scope" => ["user:read:email"]},
              refresh_token: "arefreshtoken",
              token_type: "Bearer"
            },
            user: %{
              "data" => [
                %{
                  "broadcaster_type" => "affiliate",
                  "created_at" => "2016-04-02T19:15:56.717636Z",
                  "description" => "Programming by day and programmer by night, he is the Full Stack Engineer Man",
                  "display_name" => "Talk2meGooseman",
                  "email" => "erik.guzman@guzman.codes",
                  "id" => "120750024",
                  "login" => "talk2megooseman",
                  "offline_image_url" => "https://static-cdn.jtvnw.net/jtv_user_pictures/5dd8d233-bd5b-44d2-aa07-95dc284f7c8e-channel_offline_image-1920x1080.png",
                  "profile_image_url" => "https://static-cdn.jtvnw.net/jtv_user_pictures/b0b2fc71-4d4a-484a-9aaa-16ea7e8f2bda-profile_image-300x300.png",
                  "type" => "",
                  "view_count" => 49086
                }
              ]
            }
          }
        },
        info: %{
          birthday: nil,
          description: "Programming by day and programmer by night, he is the Full Stack Engineer Man",
          email: "erik.guzman@guzman.codes",
          first_name: nil,
          image: "https://static-cdn.jtvnw.net/jtv_user_pictures/b0b2fc71-4d4a-484a-9aaa-16ea7e8f2bda-profile_image-300x300.png",
          last_name: nil,
          location: nil,
          name: "Talk2meGooseman",
          nickname: "talk2megooseman",
          phone: nil,
          urls: %{}
        },
        provider: "twitch",
        strategy: Ueberauth.Strategy.Twitch,
        uid: "updated_uid"
      }
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert UserManager.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManager.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManager.create_user(@valid_attrs)
      assert {:ok, user} == Argon2.check_pass(user, "some password", hash_key: :password)
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManager.create_user(@invalid_attrs)
    end

    test "get_or_create_user/1 with valid data return :ok with user" do
      auth = auth_info()
      user = user_fixture(%{
        email: auth.info.email,
        uid: auth.uid,
        provider: auth.provider,
        description: auth.info.description,
        username: auth.info.nickname,
        profile_image_url: auth.info.image
      })
      assert UserManager.get_or_create_user!(auth) == [user]
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = UserManager.update_user(user, @update_attrs)
      assert {:ok, user} == Argon2.check_pass(user, "some updated password", hash_key: :password)
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserManager.update_user(user, @invalid_attrs)
      assert user == UserManager.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = UserManager.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> UserManager.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = UserManager.change_user(user)
    end
  end
end
