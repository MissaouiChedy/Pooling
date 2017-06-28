defmodule Pooling.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    #
    # Launches the named Pooling.Server used as the contention point
    # as well as the supervisor managing the pool
    children = [
      worker(Pooling.Server, [:named]),
      supervisor(Pooling.PoolSupervisor, []),
    ]

    opts = [strategy: :one_for_one, name: Pooling.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
