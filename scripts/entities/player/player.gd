extends Entity
class_name Player

@export var camera: PlayerCameraComponent
@export var movement: PlayerMovementComponent
@export var shooting: ShootingComponent

var inputs_enabled: bool = false : set = _set_inputs_enabled

func _ready() -> void:
	inputs_enabled = true


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("escape"):
		inputs_enabled = !inputs_enabled
	


func _process(delta: float) -> void:
	camera.update_camera(delta)
	_handle_shooting()


func _physics_process(delta: float) -> void:
	movement.update_movement(delta)


func _handle_shooting() -> void:
	if not shooting: return
	if not shooting.firing_data:
		printerr("No firing data assigned to player shooting component.")
		return
	
	var is_auto: bool = shooting.firing_data.firing_mode == FiringData.FIRING_MODES.AUTO
	
	if not is_auto and Input.is_action_just_pressed("primary_fire"): shooting.shoot()
	if is_auto and Input.is_action_pressed("primary_fire"): shooting.shoot()


func enable_inputs() -> void:
	inputs_enabled = true


func disable_inputs() -> void:
	inputs_enabled = false


func _set_inputs_enabled(new_value: bool) -> void:
	inputs_enabled = new_value
	
	camera.can_look = inputs_enabled
	movement.can_move = inputs_enabled
	movement.can_jump = inputs_enabled
	shooting.can_shoot = inputs_enabled
	
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if inputs_enabled else Input.MOUSE_MODE_VISIBLE
