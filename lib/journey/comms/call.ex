defmodule Journey.Comms.Call do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Activities.Activity
  alias Journey.Prospects.Client
  alias Journey.Comms.Template

  schema "calls" do
    field :call_uuid, :string
    field :message, :string
    field :status, :string
    belongs_to :template, Template
    belongs_to :client, Client
    has_one :activity, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(call, attrs) do
    call
    |> cast(attrs, [:template_id, :message, :client_id, :status])
    |> validate_required([:status])
  end
end
