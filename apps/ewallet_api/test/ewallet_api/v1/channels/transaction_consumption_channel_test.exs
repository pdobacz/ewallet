defmodule EWalletAPI.V1.TransactionConsumptionChannelTest do
  use EWalletAPI.ChannelCase
  alias EWalletAPI.V1.TransactionConsumptionChannel

  describe "join/3" do
    test "joins the channel" do
      {res, _, socket} =
        socket()
        |> subscribe_and_join(TransactionConsumptionChannel, "transaction_consumption:123")

      assert res == :ok
      assert socket.topic == "transaction_consumption:123"
    end
  end
end
