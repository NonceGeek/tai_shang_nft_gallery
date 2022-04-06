defmodule TaiShangNftGallery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias TaiShangNftGallery.SyncerServer
  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TaiShangNftGallery.Repo,
      # Start the Telemetry supervisor
      TaiShangNftGalleryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TaiShangNftGallery.PubSub},
      # Start the Endpoint (http/https)
      TaiShangNftGalleryWeb.Endpoint,
      # Start a worker by calling: TaiShangNftGallery.Worker.start_link(arg)
      # {TaiShangNftGallery.Worker, arg}
      Supervisor.child_spec({SyncerServer, [nft_contract_id: 1]}, id: :web3_dev),
      # Supervisor.child_spec({SyncerServer, [nft_contract_id: 2]}, id: :map_nft),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaiShangNftGallery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaiShangNftGalleryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
