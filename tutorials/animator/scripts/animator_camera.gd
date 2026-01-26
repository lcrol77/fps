extends Camera3D

@export var look_at_position : bool = false
@export var look_at_target : Node

func _process(delta: float) -> void:
	var target_position : Vector3 = look_at_target.global_position
	if look_at_position:
		look_at(target_position)
