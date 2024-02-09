defmodule Life.Game do
  import Scenic.Primitives
  require Logger
  alias Life.Board
  @cell_size 30

  @alive 1
  @dead  0

  @blinker [
    [1, 1, 1]
  ]

  @toad [
    [0,0,1,1,1,0],
    [0,1,1,1,0,0]
  ]

  @block [
    [1, 1],
    [1, 1]
  ]

  @gosoper_glider_gun [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
    [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1],
    [1,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,1,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ]

  def total_alive(neighbours) do
    neighbours
    |> Enum.filter(fn el -> el == @alive end)
    |> Enum.count()
  end

  def game(@alive, neighbours) do
    living_count = total_alive(neighbours)
    cond do
      living_count > 3 or living_count < 2 -> @dead
      true -> @alive
    end
  end

  def game(@dead, neighbours) do
    living_count = total_alive(neighbours)

    case living_count do
      3 -> @alive
      _ -> @dead
    end
  end

  def tick(board) do
    Board.loop(board, &game/2)
  end

  def simple_blinker do
    Board.new(5, 7)
    |> Board.put(@blinker, 1, 1)
  end

  def setup do
    Board.new(60, 100)
    |> Board.put(@gosoper_glider_gun, 1, 1)
  end

  def draw(graph, board) do
    {_, graph} = Enum.reduce(board, {{0, 0}, graph}, fn row, {{x, y}, graph} ->
      {{_, y}, graph} = Enum.reduce(row, {{x, y}, graph}, fn cell_value, {{x, y}=pos, graph} ->
        {{x+1, y}, make_cell(graph, cell_value, pos)}

      end)
      {{0, y+1}, graph}
    end)
    graph
  end

  def make_cell(graph, @dead, {x, y}) do
    rect(graph, {@cell_size, @cell_size}, stroke: {1, :black}, fill: :gray, translate: {x*@cell_size, y*@cell_size})
  end
  def make_cell(graph, _, {x, y}) do
    rect(graph, {@cell_size, @cell_size}, stroke: {1, :black}, fill: :white, translate: {x*@cell_size, y*@cell_size})
  end
end
