defmodule Journey.Comms.Email do
  use Ecto.Schema
  import Ecto.Changeset
  alias Journey.Prospects.Client
  alias Journey.Comms.Template

  schema "emails" do
    field :email_uuid, Ecto.UUID
    field :subject, :string
    field :body, :string
    field :read_tracking, :boolean, default: false
    field :status, :string
    belongs_to :template, Template
    belongs_to :client, Client

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [
      :client_id,
      :template_id,
      :email_uuid,
      :subject,
      :body,
      :read_tracking,
      :status
    ])
    |> validate_required([:client_id, :subject, :body, :read_tracking, :status])
  end
end
