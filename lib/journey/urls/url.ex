defmodule Journey.URLs.URL do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Client

  schema "urls" do
    field :code, :string
    field :fallback_url, :string
    field :name, :string
    field :purpose, :string
    field :status, :string
    field :url, :string
    belongs_to :client, Client

    timestamps(type: :utc_datetime)
  end

  @doc false
  def create_changeset(url, attrs) do
    url
    |> cast(attrs, [:name, :purpose, :url, :fallback_url, :client_id, :status])
    |> validate_required([:url])
    |> check_http_https(:url)
    |> validate_url(:url)
    |> add_code()
    |> unique_constraint(:code)
  end

  @doc false
  def update_changeset(url, attrs) do
    url
    |> cast(attrs, [:name, :purpose, :url, :fallback_url, :status])
    |> check_http_https(:url)
    |> validate_url(:url)
  end

  def check_http_https(changeset, field) do
    url = get_change(changeset, field)

    case url do
      nil ->
        changeset

      _ ->
        url = if String.match?(url, ~r/^(http:|https:)/), do: url, else: "https://#{url}"

        put_change(changeset, field, url)
    end
  end

  def add_code(changeset) do
    change(changeset, %{code: generate_code(get_change(changeset, :url))})
  end

  def generate_code(url) do
    UUID.uuid5(:url, url, :hex)
    |> :erlang.phash2()
    |> Integer.to_string(16)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn field, url ->
      case :uri_string.parse(String.to_charlist(url)) do
        %{host: _} -> []
        %{path: _} -> []
        {:error, _} -> [{field, "is not a url"}]
      end
    end)
  end
end
