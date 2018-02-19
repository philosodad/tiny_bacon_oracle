defmodule NameBasicsWeb.PageController do
  use NameBasicsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
