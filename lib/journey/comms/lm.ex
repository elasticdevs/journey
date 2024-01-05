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
    field :activity_id, :integer, virtual: true

    belongs_to :template, Template
    belongs_to :client, Client
    has_one :activity, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lm, attrs) do
    lm
    |> cast(attrs, [:template_id, :message, :client_id, :activity_id, :status])
    |> validate_required([:status])
  end

  def process_vars(lm) do
    lm
    |> Map.put(:message, Template.process_vars(lm.client_id, lm.activity_id, lm.message))
  end
end
