defmodule MosquitoIdentifier.SampleView do
  use MosquitoIdentifier.Web, :view

  def render("index.json", %{samples: samples}) do
    %{samples: render_many(samples, MosquitoIdentifier.SampleView, "sample.json")}
  end

  def render("show.json", %{sample: sample}) do
    %{sample: render_one(sample, MosquitoIdentifier.SampleView, "sample.json")}
  end

  def render("sample.json", %{sample: sample}) do
    %{id: sample.id,
      location: sample.location,
      sampled_at: sample.sampled_at,
      reliability: sample.reliability,
      type: sample.type,
      species: sample.species}
  end
end
