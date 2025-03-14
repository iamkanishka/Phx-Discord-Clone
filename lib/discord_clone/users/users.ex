defmodule DiscordClone.Users.Users do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Ueberauth.Auth
  alias DiscordClone.Repo

  alias DiscordClone.Accounts.User


  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  def find_or_create_user(%Auth{info: info, credentials: credentials}) do
    IO.inspect(info)
    case Repo.get_by(User, email: info.email) do
      nil ->
        %User{}
        |> User.changeset(%{
          email: info.email,
          name: Enum.at(String.split(info.email, "@"), 0),
          image: info.image,
          token: credentials.token
        })
        |> Repo.insert()

      user ->
        {:ok, user}
    end
  end


  def create_d_user() do
    %User{}
    |> User.changeset(%{
      email: "kansihka@gmail.com",
      name: "kansihka",
      image: "https://ww.google.com",
      token: "i love you "
    })
    |> Repo.insert()
  end

end
