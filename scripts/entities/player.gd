extends CharacterBody3D

const GRAVITY = 10.0

const ACCELERATION = 7.5
const AIR_ACCELERATION = 2.5
const SPEED = 7.5
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 5.0

@export var gravity_on: bool = true
@export var can_move: bool = true
@export var can_jump: bool = true
@export var can_look: bool = true

var mouse_sensitivity: float = 0.003

@onready var head: Node3D = %Head
@onready var secondary_camera: Camera3D = %SecondaryCamera
@onready var primary_camera: Camera3D = %PrimaryCamera


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not can_look: return
		
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation_degrees.clampf(-90, 90)
	
	if Input.is_action_just_pressed("escape"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED\
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE\
		else Input.MOUSE_MODE_VISIBLE
		
		can_look = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	_handle_camera(delta)


func _physics_process(delta: float) -> void:
	_handle_movement(delta)


func _handle_camera(delta: float) -> void:
	primary_camera.global_transform = head.global_transform
	
	secondary_camera.global_transform = primary_camera.global_transform
	secondary_camera.fov = primary_camera.fov


func _handle_movement(delta: float) -> void:
	#Input
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Add Gravity
	if not is_on_floor() and gravity_on: velocity.y -= GRAVITY * delta
	
	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_jump: 
		velocity.y = JUMP_VELOCITY
		#Little horizontal boost when jumping
		velocity.x *= 1.25
		velocity.z *= 1.25
	
	# Handle Sprint
	var sprinting: bool = Input.is_action_pressed("sprint")\
						and Input.is_action_pressed("forward")\
						and is_on_floor()
	
	#Calculate Final Movement
	var wish_velocity: Vector3 = Vector3.ZERO
	wish_velocity = direction * SPEED if can_move else wish_velocity
	wish_velocity = direction * SPRINT_SPEED if sprinting else wish_velocity
	
	var accel: float = ACCELERATION if is_on_floor() else AIR_ACCELERATION
	
	velocity.x = velocity.lerp(wish_velocity, accel * delta).x
	velocity.z = velocity.lerp(wish_velocity, accel * delta).z
	
	move_and_slide()
