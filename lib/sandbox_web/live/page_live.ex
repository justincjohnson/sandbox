defmodule SandboxWeb.PageLive do
  use SandboxWeb, :live_view
  alias SandboxWeb.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, changeset: form_changeset(), params: %{})}
  end

  @impl true
  def handle_event("validate-first-name", %{"value" => value}, socket) do
    IO.inspect(socket.assigns.changeset, label: "validate-first-name")
    params = %{"first_name" => value}
    {:noreply, validate(socket, params)}
  end

  @impl true
  def handle_event("validate-last-name", %{"value" => value}, socket) do
    params = %{"last_name" => value}
    {:noreply, validate(socket, params)}
  end

  @impl true
  def handle_event("validate", %{"form" => form_params} = params, socket) do
    IO.inspect(params, label: "validate form params")
    {:noreply, validate(socket, form_params)}
  end

  @impl true
  def handle_event("submit", params, socket) do
    socket =
      socket
      |> validate(params)
      |> enroll()

    {:noreply, socket}
  end

  defp validate(socket, params) do
    # We have to merge in existing params that we save as assigns,
    # because validations with phx-focus don't get all form params passed along.
    params =
      socket.assigns.params
      |> Map.merge(params)

    changeset =
      form_changeset(params)
      |> Map.put(:action, :validate)

    assign(socket, changeset: changeset, params: params)
  end

  defp enroll(socket) do
    changeset = socket.assigns.changeset

    apply_changes(socket, changeset, changeset.valid?)
  end

  defp apply_changes(socket, changeset, true) do
    {:ok, form} = Ecto.Changeset.apply_action(changeset, :validate)

    IO.inspect(form, label: "submitted form")

    socket
    |> put_flash(:error, "Submitted!")
  end

  defp apply_changes(socket, _changeset, false), do: socket

  defp form_changeset(attrs \\ %{}) do
    %Form{}
    |> Form.changeset(attrs)
  end
end
