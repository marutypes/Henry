defmodule Henry.Utilities.Cast do
  @doc """
    iex> Henry.Utilities.Cast.map(%{"author" => "Mathew"}, as: %Henry.Site.Config{})
    %Henry.Site.Config{author: "Mathew"}

    iex> Henry.Utilities.Cast.map(%{"a-asdf" => "Mathew"}, as: %Henry.Site.Config{})
    %Henry.Site.Config{}

    iex> Henry.Utilities.Cast.map(%{"author" => "Mathew", theme: "cool"}, as: %Henry.Site.Config{})
    %Henry.Site.Config{author: "Mathew", theme: "cool"}
  """
  def map(a_map, as: a_struct) do
    keys =
      Map.keys(a_struct)
      |> Enum.filter(fn x -> x != :__struct__ end)

    processed_map =
      for key <- keys, into: %{} do
        value = get(a_map, key)
        {key, value}
      end

    a_struct = Map.merge(a_struct, processed_map)
    a_struct
  end

  @doc """
    iex> Henry.Utilities.Cast.get(%{"author" => "Mathew"}, :author)
    "Mathew"
    iex> Henry.Utilities.Cast.get(%{"lorp" => "Mathew"}, :author)
    nil
    iex> Henry.Utilities.Cast.get(%{author: "Mathew"}, :author)
    "Mathew"
  """
  def get(map, key) do
    Map.get(map, key) || Map.get(map, to_string(key))
  end
end
