defmodule TimeManagerWeb.WidgetController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Widget

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    widgets = Accounts.list_widgets()
    render(conn, "index.json", widgets: widgets)
  end

  def create(conn, widget_params) do
    with {:ok, %Widget{} = widget} <- Accounts.create_widget(widget_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.widget_path(conn, :show, widget))
      |> render("show.json", widget: widget)
    end
  end

  def show(conn, %{"id" => id}) do
    widget = Accounts.get_widget!(id)
    render(conn, "show.json", widget: widget)
  end

  def update(conn, widget_params) do
    widget = Accounts.get_widget!(widget_params["id"])

    with {:ok, %Widget{} = widget} <- Accounts.update_widget(widget, widget_params) do
      render(conn, "show.json", widget: widget)
    end
  end

  def delete(conn, %{"id" => id}) do
    widget = Accounts.get_widget!(id)

    with {:ok, %Widget{}} <- Accounts.delete_widget(widget) do
      send_resp(conn, :no_content, "")
    end
  end
end
