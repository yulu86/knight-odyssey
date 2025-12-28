class_name OnFloorState
extends PlayerStateBase


func process(_delta: float) -> void:
    if player == null:
        return

    # Check if player has left the ground
    if not player.is_on_floor():
        transition_state(PlayerState.State.FALL)