defmodule Journey.Comms do
  @moduledoc """
  The Comms context.
  """

  import Ecto.Query, warn: false

  alias Journey.Repo
  alias Journey.Comms.Template
  alias Journey.Activities.Activity
  alias Journey.Accounts.User

  def preload() do
    [:template, [activity: [:user, :url, :visit]], [client: [:user, :company]]]
  end

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates(comm_type \\ nil) do
    case comm_type do
      nil ->
        Repo.all(Template)

      _ ->
        from(t in Template, where: t.comm_type == ^comm_type)
        |> Repo.all()
    end
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id), do: Repo.get!(Template, id)

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    %Template{}
    |> Template.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    template
    |> Template.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    Repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{data: %Template{}}

  """
  def change_template(%Template{} = template, attrs \\ %{}) do
    Template.changeset(template, attrs)
  end

  alias Journey.Comms.Call

  @doc """
  Returns the list of calls.

  ## Examples

      iex> list_calls()
      [%Call{}, ...]

  """
  def list_calls(current_user) do
    Repo.all(
      from call in Call,
        join: a in Activity,
        on: a.call_id == call.id,
        join: u in User,
        on: u.id == a.user_id,
        where:
          ^current_user.level == 0 or is_nil(u) or
            (not is_nil(u.level) and u.level >= ^current_user.level),
        order_by: [desc_nulls_last: :updated_at],
        preload: ^preload()
    )
  end

  @doc """
  Gets a single call.

  Raises `Ecto.NoResultsError` if the Call does not exist.

  ## Examples

      iex> get_call!(123)
      %Call{}

      iex> get_call!(456)
      ** (Ecto.NoResultsError)

  """
  def get_call!(id), do: Repo.get!(Call, id) |> Repo.preload([:template, :client, :activity])

  def get_call_one!(current_user, id),
    do:
      Repo.one!(
        from call in Call,
          join: a in Activity,
          on: a.call_id == call.id,
          join: u in User,
          on: u.id == a.user_id,
          where:
            (^current_user.level == 0 or is_nil(u) or
               (not is_nil(u.level) and u.level >= ^current_user.level)) and
              call.id == ^id,
          preload: ^preload()
      )

  @doc """
  Creates a call.

  ## Examples

      iex> create_call(%{field: value})
      {:ok, %Call{}}

      iex> create_call(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_call(attrs \\ %{}) do
    %Call{}
    |> Call.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a call.

  ## Examples

      iex> update_call(call, %{field: new_value})
      {:ok, %Call{}}

      iex> update_call(call, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_call(%Call{} = call, attrs) do
    call
    |> Call.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a call.

  ## Examples

      iex> delete_call(call)
      {:ok, %Call{}}

      iex> delete_call(call)
      {:error, %Ecto.Changeset{}}

  """
  def delete_call(%Call{} = call) do
    Repo.delete(call)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking call changes.

  ## Examples

      iex> change_call(call)
      %Ecto.Changeset{data: %Call{}}

  """
  def change_call(%Call{} = call, attrs \\ %{}) do
    Call.changeset(call, attrs)
  end

  alias Journey.Comms.LM

  @doc """
  Returns the list of lms.

  ## Examples

      iex> list_lms()
      [%LM{}, ...]

  """
  def list_lms(current_user) do
    Repo.all(
      from lm in LM,
        join: a in Activity,
        on: a.lm_id == lm.id,
        join: u in User,
        on: u.id == a.user_id,
        where:
          ^current_user.level == 0 or is_nil(u) or
            (not is_nil(u.level) and u.level >= ^current_user.level),
        order_by: [desc_nulls_last: :updated_at],
        preload: ^preload()
    )
  end

  @doc """
  Gets a single lm.

  Raises `Ecto.NoResultsError` if the Lm does not exist.

  ## Examples

      iex> get_lm!(123)
      %LM{}

      iex> get_lm!(456)
      ** (Ecto.NoResultsError)

  """
  def get_lm!(id), do: Repo.get!(LM, id) |> Repo.preload([:template, :client, :activity])

  def get_lm_one!(current_user, id),
    do:
      Repo.one!(
        from lm in LM,
          join: a in Activity,
          on: a.lm_id == lm.id,
          join: u in User,
          on: u.id == a.user_id,
          where:
            (^current_user.level == 0 or is_nil(u) or
               (not is_nil(u.level) and u.level >= ^current_user.level)) and
              lm.id == ^id,
          preload: ^preload()
      )

  @doc """
  Creates a lm.

  ## Examples

      iex> create_lm(%{field: value})
      {:ok, %LM{}}

      iex> create_lm(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_lm(attrs \\ %{}) do
    %LM{}
    |> LM.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a lm.

  ## Examples

      iex> update_lm(lm, %{field: new_value})
      {:ok, %LM{}}

      iex> update_lm(lm, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_lm(%LM{} = lm, attrs) do
    lm
    |> LM.changeset(attrs)
    |> Repo.update()
  end

  def update_lm!(%LM{} = lm, attrs) do
    lm
    |> LM.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a lm.

  ## Examples

      iex> delete_lm(lm)
      {:ok, %LM{}}

      iex> delete_lm(lm)
      {:error, %Ecto.Changeset{}}

  """
  def delete_lm(%LM{} = lm) do
    Repo.delete(lm)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking lm changes.

  ## Examples

      iex> change_lm(lm)
      %Ecto.Changeset{data: %LM{}}

  """
  def change_lm(%LM{} = lm, attrs \\ %{}) do
    LM.changeset(lm, attrs)
  end

  alias Journey.Comms.Email

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails(current_user) do
    Repo.all(
      from email in Email,
        join: a in Activity,
        on: a.email_id == email.id,
        join: u in User,
        on: u.id == a.user_id,
        where:
          ^current_user.level == 0 or is_nil(u) or
            (not is_nil(u.level) and u.level >= ^current_user.level),
        order_by: [desc_nulls_last: :updated_at],
        preload: ^preload()
    )
  end

  @doc """
  Gets a single email.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(id), do: Repo.get!(Email, id) |> Repo.preload([:template, :client, :activity])

  def get_email_one!(current_user, id),
    do:
      Repo.one!(
        from email in Email,
          join: a in Activity,
          on: a.email_id == email.id,
          join: u in User,
          on: u.id == a.user_id,
          where:
            (^current_user.level == 0 or is_nil(u) or
               (not is_nil(u.level) and u.level >= ^current_user.level)) and
              email.id == ^id,
          preload: ^preload()
      )

  @doc """
  Creates a email.

  ## Examples

      iex> create_email(%{field: value})
      {:ok, %Email{}}

      iex> create_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(attrs \\ %{}) do
    %Email{}
    |> Email.changeset(attrs)
    |> Repo.insert()
  end

  def create_email!(attrs \\ %{}) do
    %Email{}
    |> Email.changeset(attrs)
    |> Repo.insert!()
  end

  @doc """
  Updates a email.

  ## Examples

      iex> update_email(email, %{field: new_value})
      {:ok, %Email{}}

      iex> update_email(email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email(%Email{} = email, attrs) do
    email
    |> Email.changeset(attrs)
    |> Repo.update()
  end

  def update_email!(%Email{} = email, attrs) do
    email
    |> Email.changeset(attrs)
    |> Repo.update!()
  end

  @doc """
  Deletes a email.

  ## Examples

      iex> delete_email(email)
      {:ok, %Email{}}

      iex> delete_email(email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email changes.

  ## Examples

      iex> change_email(email)
      %Ecto.Changeset{data: %Email{}}

  """
  def change_email(%Email{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end

  def templates_options(comm_type \\ nil) do
    Enum.reduce(list_templates(comm_type), Keyword.new(), fn t, ts ->
      Keyword.put_new(ts, String.to_atom(t.name), t.id)
    end)
  end

  def templates_map(comm_type \\ nil) do
    Enum.reduce(list_templates(comm_type), %{}, fn template, map ->
      Map.put_new(map, template.id, Ecto.embedded_dump(template, :json))
    end)
  end
end
