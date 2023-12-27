defmodule JourneyWeb.ActivityController do
  use JourneyWeb, :controller

  alias Journey.Activities
  alias Journey.Activities.Activity

  def index(conn, _params) do
    in_last_secs = get_in_last_secs_from_cookie(conn)

    activities =
      Activities.list_activities(conn.assigns.current_user, %{in_last_secs: in_last_secs})

    render(conn, :index, activities: activities)
  end

  def new(conn, _params) do
    changeset = Activities.change_activity(%Activity{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"activity" => activity_params}) do
    case Activities.create_activity(activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: ~p"/activities/#{activity}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activity = Activities.get_activity_one!(conn.assigns.current_user, id)
    render(conn, :show, activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Activities.get_activity_one!(conn.assigns.current_user, id)
    changeset = Activities.change_activity(activity)
    render(conn, :edit, activity: activity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Activities.get_activity_one!(conn.assigns.current_user, id)

    case Activities.update_activity(activity, activity_params) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: ~p"/activities/#{activity}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, activity: activity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Activities.get_activity_one!(conn.assigns.current_user, id)
    {:ok, _activity} = Activities.delete_activity(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: ~p"/activities")
  end
end
