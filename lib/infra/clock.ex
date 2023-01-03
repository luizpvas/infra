defmodule Infra.Clock do
  def utc_now do
    Process.get(:clock_utc_now) || DateTime.utc_now()
  end

  def from_utc_now(amount_to_add, unit) do
    utc_now() |> DateTime.add(amount_to_add, unit)
  end

  def freeze(now \\ nil) do
    Process.put(:clock_utc_now, now || DateTime.truncate(utc_now(), :second))
  end
end
