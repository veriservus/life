defmodule Life.Board do
  require Logger
  alias MatrixReloaded.Matrix, as: M

  def new(y, x) do
    {_, m} = M.new({y, x})
    m
  end

  def put(matrix, seed, y, x) do
    {_, m } = M.update(matrix, seed, {y, x})
    m
  end

  @spec neighbour_points(number(), number(), {any(), any()}) :: list()
  def neighbour_points(y, x, {max_y, max_x}) do
    x_left  = x-1
    x_right = x+1
    y_up    = y-1
    y_down  = y+1

    [
      {y_up, x_left},   {y_up, x},   {y_up, x_right},
      {y, x_left},                   {y, x_right},
      {y_down, x_left}, {y_down, x}, {y_down, x_right}
    ]
    |> Enum.reject(fn {y, x} -> x < 0 or y < 0 or x > max_x or y > max_y end)
  end

  def neighbours_of(m, {y, x}) do
    neighbours_of(m, {y, x}, neighbour_points(y, x, M.size(m)), [])
  end

  def neighbours_of(m, {y, x}, [point | points], neighbours) do
    new_neighbours = case M.get_element(m, point) do
      {:ok, el} -> [el | neighbours]
      _ -> neighbours
    end

    neighbours_of(m, {y, x}, points, new_neighbours)
  end

  def neighbours_of(_m, _p, [], neighbours) do
    neighbours
  end

  def loop(m, f) do
    m
    |> Enum.with_index()
    |> Enum.map(fn {row, row_num} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {el, col_num} ->
        f.(el, neighbours_of(m, {row_num, col_num}))
      end)
    end)
  end
end
