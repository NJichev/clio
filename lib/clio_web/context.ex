defmodule ClioWeb.Context do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(%{cookies: %{"token" => token}} = conn, _) do
    {:ok, user} = Phoenix.Token.verify(ClioWeb.Endpoint, "The salt bro", token)
    IO.puts "\nasd\n"
    put_private(conn, :absinthe, %{context: %{current_user: user}})
  end
  def call(conn, _) do
    IO.inspect conn.cookies
    conn
  end
end