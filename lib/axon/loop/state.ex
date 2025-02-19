defmodule Axon.Loop.State do
  @moduledoc """
  Accumulated state in an Axon.Loop.

  Loop state is a struct:

      %State{
        epoch: tensor(),
        max_epoch: tensor(),
        iteration: tensor(),
        max_iteration: tensor(),
        metrics: map(string(), container()),
        times: list(number()),
        step_state: container()
      }

  `epoch` is the current epoch, starting at 0, of the nested loop.
  Defaults to 0.

  `max_epoch` is the maximum number of epochs the loop should run
  for. Defaults to 1.

  `iteration` is the current iteration of the inner loop. In supervised
  settings, this will be the current batch. Defaults to 0.

  `max_iteration` is the maximum number of iterations the loop should
  run a given epoch for. Defaults to -1 (no max).

  `metrics` is a map of `%{"metric_name" => value}` which accumulates metrics
  over the course of loop processing. Defaults to an empty map.

  `times` is a map of `%{epoch_number => value}` which maps a given epoch
  to the processing time. Defaults to an empty map.

  `step_state` is the step state as defined by the loop's processing
  initialization and update functions. `step_state` is a required field.
  """
  # TODO(seanmor5): We should not send `:times` to the device. We need
  # a way in Nx/EXLA to mark `:times` as a static property which is
  # not to be touched at JIT time.
  @enforce_keys [:step_state]
  @derive {Nx.Container,
           containers: [:step_state, :epoch, :max_epoch, :iteration, :max_iteration, :metrics]}
  defstruct [
    :step_state,
    epoch: 0,
    max_epoch: 1,
    iteration: 0,
    max_iteration: -1,
    metrics: %{},
    times: %{}
  ]
end
