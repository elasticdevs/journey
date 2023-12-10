defmodule JourneyWeb.TargetController do
  use JourneyWeb, :controller

  alias Journey.Prospects
  alias Journey.Prospects.Target

  def index(conn, _params) do
    targets = Prospects.list_targets()
    render(conn, :index, targets: targets)
  end

  def new(conn, _params) do
    changeset = Prospects.change_target(%Target{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"target" => target_params}) do
    case Prospects.create_target(target_params) do
      {:ok, target} ->
        conn
        |> put_flash(:info, "Target created successfully.")
        |> redirect(to: ~p"/targets/#{target}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    target = Prospects.get_target!(id)
    render(conn, :show, target: target)
  end

  def edit(conn, %{"id" => id}) do
    target = Prospects.get_target!(id)
    changeset = Prospects.change_target(target)
    render(conn, :edit, target: target, changeset: changeset)
  end

  def update(conn, %{"id" => id, "target" => target_params}) do
    target = Prospects.get_target!(id)

    case Prospects.update_target(target, target_params) do
      {:ok, target} ->
        conn
        |> put_flash(:info, "Target updated successfully.")
        |> redirect(to: ~p"/targets/#{target}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, target: target, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    target = Prospects.get_target!(id)
    {:ok, _target} = Prospects.delete_target(target)

    conn
    |> put_flash(:info, "Target deleted successfully.")
    |> redirect(to: ~p"/targets")
  end
end
