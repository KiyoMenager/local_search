defmodule DataLoader do
  require Logger

  def load(filename) do
    Logger.info "Loading data..."
    root_dir = File.cwd!
    path =
      Path.join(~w(#{root_dir} data))
      |> Path.expand
    datas = CSVLixir.read(path <> "/" <> filename) |> Enum.to_list

    {_headers, coords} = datas |> Enum.split(6)
    route = coords |> Enum.reduce([], &build_and_add_node(&2, &1))

    Logger.info "Data loaded."
    route
  end

  def get_rid_headers(datas) do
    datas
    |> Enum.drop_while(fn [str_data] ->
      case str_data |> String.split(["  ", " "]) do
        [str_id, _str_x, _str_y] ->
          case Integer.parse(str_id) do
            :error -> true
            _id -> false
          end
        _ -> true
      end
    end)
  end

  def build_and_add_node(nodes, []), do: nodes
  def build_and_add_node(nodes, ["EOF"]), do: nodes
  def build_and_add_node(nodes, [str_coord]) do
    [str_id, str_x, str_y] = str_coord |> String.split(" ")

    {id, _} = str_id |> Integer.parse
    {x, _}  = str_x  |> Float.parse
    {y, _}  = str_y  |> Float.parse

    [Point.new(id, x, y)|nodes]
  end
end
