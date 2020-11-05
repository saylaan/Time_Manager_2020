defmodule TimeManager.AccountsTest do
  use TimeManager.DataCase

  alias TimeManager.Accounts

  describe "users" do
    alias TimeManager.Accounts.User

    @valid_attrs %{adming: true, email: "some email", grister: true, hash: "some hash", manager: true, role: "some role", salt: "some salt", username: "some username"}
    @update_attrs %{adming: false, email: "some updated email", grister: false, hash: "some updated hash", manager: false, role: "some updated role", salt: "some updated salt", username: "some updated username"}
    @invalid_attrs %{adming: nil, email: nil, grister: nil, hash: nil, manager: nil, role: nil, salt: nil, username: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.adming == true
      assert user.email == "some email"
      assert user.grister == true
      assert user.hash == "some hash"
      assert user.manager == true
      assert user.role == "some role"
      assert user.salt == "some salt"
      assert user.username == "some username"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.adming == false
      assert user.email == "some updated email"
      assert user.grister == false
      assert user.hash == "some updated hash"
      assert user.manager == false
      assert user.role == "some updated role"
      assert user.salt == "some updated salt"
      assert user.username == "some updated username"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "authentication" do
    alias TimeManager.Accounts.User

    test "register for an account with valid information" do
    pre_count = count_of(Account)
    params = valid_account_params()

    result = Accounts.register(params)

    assert {:ok, %Account{}} = result
    assert pre_count + 1 == count_of(Account)

    test "register for an account with an existing email address" do
      params = valid_account_params()
      Repo.insert!(%Account{email: params.info.email})

      pre_count = count_of(Account)

      result = Accounts.register(params)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == count_of(Account)
    end

    test "register for an account without matching password and confirmation" do
      pre_count = count_of(Account)
      %{credentials: credentials} = params = valid_account_params()

      params = %{
        params
        | credentials: %{
            credentials
            | other: %{
                password: "superdupersecret",
                password_confirmation: "somethingelse"
              }
          }
      }
      result = Accounts.register(params)

      assert {:error, %Ecto.Changeset{}} = result
      assert pre_count == count_of(Account)
    end

    defp count_of(queryable) do
      Yauth.Repo.aggregate(queryable, :count, :id)
    end

    defp valid_account_params do
      %Ueberauth.Auth{
        credentials: %Ueberauth.Auth.Credentials{
          other: %{
            password: "superdupersecret",
            password_confirmation: "superdupersecret"
          }
        },
        info: %Ueberauth.Auth.Info{
          email: "me@example.com"
        }
      }
    end
  end
  
  describe "teams" do
    alias TimeManager.Accounts.Team

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def team_fixture(attrs \\ %{}) do
      {:ok, team} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_team()

      team
    end

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Accounts.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Accounts.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      assert {:ok, %Team{} = team} = Accounts.create_team(@valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      assert {:ok, %Team{} = team} = Accounts.update_team(team, @update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_team(team, @invalid_attrs)
      assert team == Accounts.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Accounts.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Accounts.change_team(team)
    end
  end

  describe "teamusers" do
    alias TimeManager.Accounts.TeamUser

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def team_user_fixture(attrs \\ %{}) do
      {:ok, team_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_team_user()

      team_user
    end

    test "list_teamusers/0 returns all teamusers" do
      team_user = team_user_fixture()
      assert Accounts.list_teamusers() == [team_user]
    end

    test "get_team_user!/1 returns the team_user with given id" do
      team_user = team_user_fixture()
      assert Accounts.get_team_user!(team_user.id) == team_user
    end

    test "create_team_user/1 with valid data creates a team_user" do
      assert {:ok, %TeamUser{} = team_user} = Accounts.create_team_user(@valid_attrs)
    end

    test "create_team_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_team_user(@invalid_attrs)
    end

    test "update_team_user/2 with valid data updates the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{} = team_user} = Accounts.update_team_user(team_user, @update_attrs)
    end

    test "update_team_user/2 with invalid data returns error changeset" do
      team_user = team_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_team_user(team_user, @invalid_attrs)
      assert team_user == Accounts.get_team_user!(team_user.id)
    end

    test "delete_team_user/1 deletes the team_user" do
      team_user = team_user_fixture()
      assert {:ok, %TeamUser{}} = Accounts.delete_team_user(team_user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_team_user!(team_user.id) end
    end

    test "change_team_user/1 returns a team_user changeset" do
      team_user = team_user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_team_user(team_user)
    end
  end

  describe "widgets" do
    alias TimeManager.Accounts.Widget

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def widget_fixture(attrs \\ %{}) do
      {:ok, widget} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_widget()

      widget
    end

    test "list_widgets/0 returns all widgets" do
      widget = widget_fixture()
      assert Accounts.list_widgets() == [widget]
    end

    test "get_widget!/1 returns the widget with given id" do
      widget = widget_fixture()
      assert Accounts.get_widget!(widget.id) == widget
    end

    test "create_widget/1 with valid data creates a widget" do
      assert {:ok, %Widget{} = widget} = Accounts.create_widget(@valid_attrs)
      assert widget.description == "some description"
      assert widget.name == "some name"
    end

    test "create_widget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_widget(@invalid_attrs)
    end

    test "update_widget/2 with valid data updates the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{} = widget} = Accounts.update_widget(widget, @update_attrs)
      assert widget.description == "some updated description"
      assert widget.name == "some updated name"
    end

    test "update_widget/2 with invalid data returns error changeset" do
      widget = widget_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_widget(widget, @invalid_attrs)
      assert widget == Accounts.get_widget!(widget.id)
    end

    test "delete_widget/1 deletes the widget" do
      widget = widget_fixture()
      assert {:ok, %Widget{}} = Accounts.delete_widget(widget)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_widget!(widget.id) end
    end

    test "change_widget/1 returns a widget changeset" do
      widget = widget_fixture()
      assert %Ecto.Changeset{} = Accounts.change_widget(widget)
    end
  end

  describe "widgetusers" do
    alias TimeManager.Accounts.WidgetUser

    @valid_attrs %{param_one: "some param_one", param_two: "some param_two", value_one: 120.5, value_two: 120.5, x: 42, y: 42}
    @update_attrs %{param_one: "some updated param_one", param_two: "some updated param_two", value_one: 456.7, value_two: 456.7, x: 43, y: 43}
    @invalid_attrs %{param_one: nil, param_two: nil, value_one: nil, value_two: nil, x: nil, y: nil}

    def widget_user_fixture(attrs \\ %{}) do
      {:ok, widget_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_widget_user()

      widget_user
    end

    test "list_widgetusers/0 returns all widgetusers" do
      widget_user = widget_user_fixture()
      assert Accounts.list_widgetusers() == [widget_user]
    end

    test "get_widget_user!/1 returns the widget_user with given id" do
      widget_user = widget_user_fixture()
      assert Accounts.get_widget_user!(widget_user.id) == widget_user
    end

    test "create_widget_user/1 with valid data creates a widget_user" do
      assert {:ok, %WidgetUser{} = widget_user} = Accounts.create_widget_user(@valid_attrs)
      assert widget_user.param_one == "some param_one"
      assert widget_user.param_two == "some param_two"
      assert widget_user.value_one == 120.5
      assert widget_user.value_two == 120.5
      assert widget_user.x == 42
      assert widget_user.y == 42
    end

    test "create_widget_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_widget_user(@invalid_attrs)
    end

    test "update_widget_user/2 with valid data updates the widget_user" do
      widget_user = widget_user_fixture()
      assert {:ok, %WidgetUser{} = widget_user} = Accounts.update_widget_user(widget_user, @update_attrs)
      assert widget_user.param_one == "some updated param_one"
      assert widget_user.param_two == "some updated param_two"
      assert widget_user.value_one == 456.7
      assert widget_user.value_two == 456.7
      assert widget_user.x == 43
      assert widget_user.y == 43
    end

    test "update_widget_user/2 with invalid data returns error changeset" do
      widget_user = widget_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_widget_user(widget_user, @invalid_attrs)
      assert widget_user == Accounts.get_widget_user!(widget_user.id)
    end

    test "delete_widget_user/1 deletes the widget_user" do
      widget_user = widget_user_fixture()
      assert {:ok, %WidgetUser{}} = Accounts.delete_widget_user(widget_user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_widget_user!(widget_user.id) end
    end

    test "change_widget_user/1 returns a widget_user changeset" do
      widget_user = widget_user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_widget_user(widget_user)
    end
  end
end
