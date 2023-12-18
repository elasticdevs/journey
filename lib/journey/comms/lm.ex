defmodule Journey.Comms.LM do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Client
  alias Journey.Comms.Template
  alias Journey.Activities.Activity

  schema "lms" do
    field :lm_uuid, :string
    field :message, :string
    field :status, :string
    belongs_to :template, Template
    belongs_to :client, Client
    has_one :activity, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lm, attrs) do
    lm
    |> cast(attrs, [:lm_uuid, :template_id, :message, :client_id, :status])
    |> validate_required([:status])
  end
end
