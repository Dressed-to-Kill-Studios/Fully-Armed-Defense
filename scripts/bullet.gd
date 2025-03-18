extends Node3D
class_name Bullet

@export var damage_registry: DamageRegistry

@export var speed: float = 50.0
@export var max_distance: float = 100.0
@export var disable_flyby_detect : bool = false

var fly_direction: Vector3
var prev_pos: Vector3 = Vector3()

var distance_travelled: float = 0

var hit_something : bool = false


func _ready() -> void:
	fly_direction = global_transform.basis.z
	prev_pos = global_transform.origin
	


func _physics_process(delta: float) -> void:
	var new_pos: Vector3 = global_transform.origin - (fly_direction * speed * delta)
	
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(prev_pos, new_pos)
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_query)
	
	if not result.is_empty():
		var collider: Node = result.collider 
		var collision_point: Vector3 = result.position
		
		hit_something = true
		
		if collider is Enemy: 
			pass
		else:
			new_pos = collision_point
		
		destroy()
	
	distance_travelled += prev_pos.distance_to(new_pos)
	if distance_travelled >= max_distance: destroy()
	
	
	global_transform.origin = new_pos
	prev_pos = new_pos
	


func destroy() -> void:
	queue_free()
