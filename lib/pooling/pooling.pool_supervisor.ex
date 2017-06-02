defmodule Pooling.PoolSupervisor do
  use Supervisor

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    pool_options = [
      name: {:local, :calc_pool},
      worker_module: Pooling.Server,
      size: Pooling.core_count(),
      max_overflow: Pooling.core_count() + 2
    ]

    children = [
      :poolboy.child_spec(:calc_pool, pool_options, [:unamed])   
    ]
    supervise(children, strategy: :one_for_one)
  end
end
