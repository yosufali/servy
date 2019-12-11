defmodule Servy.PledgeServer do
  def create_pledge(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)

    # cache pledge
    [{"larry", 10}]
  end

  def recent_pledges do
    # return most recent 3 pledges

    [{"larry", 10}]
  end

  defp send_pledge_to_service(_name, _amount) do
    # code to send to pledge service

    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
