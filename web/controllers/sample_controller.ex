defmodule MosquitoIdentifier.SampleController do
  use MosquitoIdentifier.Web, :controller

  alias MosquitoIdentifier.Sample

  plug :scrub_params, "sample" when action in [:create, :update]

  def index(conn, %{"lat" => lat, "lon" => lon}) do
    samples =
      Sample.query_nearby({lon, lat})
      |> Repo.all

    render(conn, "index.json", samples: samples)
  end

  def create(conn, %{"sample" => sample_params}) do
    changeset = Sample.changeset(%Sample{}, sample_params)

    case Repo.insert(changeset) do
      {:ok, sample} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", sample_path(conn, :show, sample))
        |> render("show.json", sample: sample)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MosquitoIdentifier.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    sample = Repo.get!(Sample, id)
    render(conn, "show.json", sample: sample)
  end

  def update(conn, %{"id" => id, "sample" => sample_params}) do
    sample = Repo.get!(Sample, id)
    changeset = Sample.changeset(sample, sample_params)

    case Repo.update(changeset) do
      {:ok, sample} ->
        render(conn, "show.json", sample: sample)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(MosquitoIdentifier.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    sample = Repo.get!(Sample, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(sample)

    send_resp(conn, :no_content, "")
  end
end
