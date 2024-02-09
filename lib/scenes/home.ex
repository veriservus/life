defmodule Life.Scene.Home do
  use Scenic.Scene
  require Logger

  alias Scenic.Graph
  alias Life.Game


  def init(scene, _param, _opts) do
    #{width, height} = scene.viewport.size
    request_input(scene, [:key])

    {:ok, draw(scene, Game.setup())}
  end

  @spec handle_input(any(), any(), any()) :: {:noreply, any()}
  def handle_input({:key, {_key, 1, _}}, _id, %{assigns: %{board: board}}=scene) do
    {:noreply, draw(scene, Game.tick(board))}
  end

  def handle_input(event, _context, scene) do
    Logger.info("Received event: #{inspect(event)}")
    {:noreply, scene}
  end

  defp draw(scene, board) do
    graph =
      Graph.build()
      |> Game.draw(board)

    scene
    |> assign(board: board)
    |> push_graph(graph)
  end
end
