defmodule Journey.ActivitiesTest do
  use Journey.DataCase

  alias Journey.Activities

  describe "activities" do
    alias Journey.Activities.Activity

    import Journey.ActivitiesFixtures

    @invalid_attrs %{details: nil, executed_at: nil, message: nil, scheduled_at: nil, status: nil, type: nil}

    test "list_activities/0 returns all activities" do
      activity = activity_fixture()
      assert Activities.list_activities() == [activity]
    end

    test "get_activity!/1 returns the activity with given id" do
      activity = activity_fixture()
      assert Activities.get_activity!(activity.id) == activity
    end

    test "create_activity/1 with valid data creates a activity" do
      valid_attrs = %{details: "some details", executed_at: "some executed_at", message: "some message", scheduled_at: "some scheduled_at", status: "some status", type: "some type"}

      assert {:ok, %Activity{} = activity} = Activities.create_activity(valid_attrs)
      assert activity.details == "some details"
      assert activity.executed_at == "some executed_at"
      assert activity.message == "some message"
      assert activity.scheduled_at == "some scheduled_at"
      assert activity.status == "some status"
      assert activity.type == "some type"
    end

    test "create_activity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Activities.create_activity(@invalid_attrs)
    end

    test "update_activity/2 with valid data updates the activity" do
      activity = activity_fixture()
      update_attrs = %{details: "some updated details", executed_at: "some updated executed_at", message: "some updated message", scheduled_at: "some updated scheduled_at", status: "some updated status", type: "some updated type"}

      assert {:ok, %Activity{} = activity} = Activities.update_activity(activity, update_attrs)
      assert activity.details == "some updated details"
      assert activity.executed_at == "some updated executed_at"
      assert activity.message == "some updated message"
      assert activity.scheduled_at == "some updated scheduled_at"
      assert activity.status == "some updated status"
      assert activity.type == "some updated type"
    end

    test "update_activity/2 with invalid data returns error changeset" do
      activity = activity_fixture()
      assert {:error, %Ecto.Changeset{}} = Activities.update_activity(activity, @invalid_attrs)
      assert activity == Activities.get_activity!(activity.id)
    end

    test "delete_activity/1 deletes the activity" do
      activity = activity_fixture()
      assert {:ok, %Activity{}} = Activities.delete_activity(activity)
      assert_raise Ecto.NoResultsError, fn -> Activities.get_activity!(activity.id) end
    end

    test "change_activity/1 returns a activity changeset" do
      activity = activity_fixture()
      assert %Ecto.Changeset{} = Activities.change_activity(activity)
    end
  end
end
