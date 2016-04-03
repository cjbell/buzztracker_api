defmodule MosquitoIdentifier.Sample do
  use MosquitoIdentifier.Web, :model

  schema "samples" do
    field :location, Geo.Point
    field :sampled_at, Ecto.DateTime
    field :reliability, :float
    field :type, :string
    field :species, :string

    timestamps
  end

  @required_fields ~w(location sampled_at reliability type)
  @optional_fields ~w()
  @species ~w(aedes culex anopheles)
  @types ~w(adult lavae eggs)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    params = parse_location(params)

    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:species, @species)
  end

  def parse_location(%{lat: lat, lon: lon} = params) do
    params
    |> Map.drop([:lat, :lon])
    |> Map.put(:location, %Geo.Point{coordinates: {lon, lat}})
  end

  def query_nearby({lon, lat} = coords) do
    point = %Geo.Point{coordinates: coords}

    from s in CG.Sample,
      select: {s, fragment(
        "round(?) as distance",
        st_distance(s.location, ^point)
      )},
      where: st_dwithin(s.location, ^point, ^3218),
      order_by: fragment("distance")
  end
end
