extends Node
class_name PlayerMovement

const GRAVITY = 10.0

const ACCELERATION = 7.5
const AIR_ACCELERATION = 2.5
const SPEED = 7.5
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 5.0

@export var gravity_on: bool = true
@export var can_move: bool = true
@export var can_jump: bool = true
@export var max_jumps: int = 1

var current_jumps: int = 0

@onready var player: Player = $".."


func update_movement(delta: float) -> void:
	#Input
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Add Gravity
	if not player.is_on_floor() and gravity_on: player.velocity.y -= GRAVITY * delta
	
	# Handle Jump
	if player.is_on_floor(): current_jumps = 0
	
	if Input.is_action_just_pressed("jump") and can_jump and current_jumps < max_jumps: 
		current_jumps += 1
		player.velocity.y = JUMP_VELOCITY
		#Little horizontal boost when jumping
		player.velocity.x *= 1.25
		player.velocity.z *= 1.25
	
	# Handle Sprint
	var sprinting: bool = Input.is_action_pressed("sprint")\
						and Input.is_action_pressed("forward")\
						and player.is_on_floor()
	
	#Calculate Final Movement
	var wish_velocity: Vector3 = Vector3.ZERO
	wish_velocity = direction * SPEED if can_move else wish_velocity
	wish_velocity = direction * SPRINT_SPEED if sprinting else wish_velocity
	
	var accel: float = ACCELERATION if player.is_on_floor() else AIR_ACCELERATION
	
	player.velocity.x = player.velocity.lerp(wish_velocity, accel * delta).x
	player.velocity.z = player.velocity.lerp(wish_velocity, accel * delta).z
	
	player.move_and_slide()
