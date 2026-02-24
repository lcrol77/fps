class_name CameraEffects extends Camera3D

@export_category("References")
@export var player: PlayerController

@export_category("Effects")
@export var enable_tilt: bool = true
@export var enable_fall_kick: bool = true

@export_category("Kick and Recoil Settings")
@export_group("Run Tilt")
@export var run_pitch: float = 0.1  # Degrees
@export var run_roll: float = 0.25  # Degrees
@export var max_pitch: float = 1.0  # Degrees
@export var max_roll: float = 2.5  # Degrees
@export_group("Camera Kick")
@export_subgroup("Fall Kick")
@export var fall_time: float = 0.3

var _fall_value: float = 0.0
var _fall_timer: float = 0.0


func _process(delta: float) -> void:
	calculate_view_offset(delta)


func calculate_view_offset(delta: float) -> void:
	if not player:
		return
	_fall_timer -= delta
	var velocity = player.velocity
	var angles = Vector3.ZERO
	var offset = Vector3.ZERO
	# Camera Tilt
	if enable_tilt:
		var forward = global_transform.basis.z
		var right = global_transform.basis.x

		var forward_dot = velocity.dot(forward)
		var forward_tilt = clampf(forward_dot * deg_to_rad(run_pitch), deg_to_rad(-max_pitch), deg_to_rad(max_pitch))
		angles.z += forward_tilt

		var right_dot = velocity.dot(right)
		var side_tilt = clampf(right_dot * deg_to_rad(run_roll), deg_to_rad(-max_roll), deg_to_rad(max_roll))
		angles.z -= side_tilt
	# Fall Kick
	if enable_fall_kick:
		var fall_ratio = max(0.0, _fall_timer / fall_time)
		var fall_kick_amount = fall_ratio * _fall_value
		angles.x -= fall_kick_amount
		offset.y -= fall_kick_amount
	position = offset
	rotation = angles


func add_fall_kick(fall_strength: float):
	_fall_value = deg_to_rad(fall_strength)
	_fall_timer = fall_time
