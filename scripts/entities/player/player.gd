extends Entity
class_name Player

@export var movement: PlayerMovementComponent
@export var camera: PlayerCameraComponent

var inputs_enabled: bool = false : set = _set_inputs_enabled

func _ready() -> void:
	inputs_enabled = true


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		inputs_enabled = !inputs_enabled
	


func _process(delta: float) -> void:
	camera.update_camera(delta)


func _physics_process(delta: float) -> void:
	movement.update_movement(delta)


func enable_inputs() -> void:
	inputs_enabled = true


func disable_inputs() -> void:
	inputs_enabled = false


func _set_inputs_enabled(new_value: bool) -> void:
	inputs_enabled = new_value
	
	camera.can_look = inputs_enabled
	movement.can_move = inputs_enabled
	movement.can_jump = inputs_enabled
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if inputs_enabled else Input.MOUSE_MODE_VISIBLE
