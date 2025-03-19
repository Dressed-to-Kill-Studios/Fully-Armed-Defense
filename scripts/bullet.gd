extends Node3D
class_name Bullet

@export var damage_registry: DamageRegistry

@export var speed: float = 50.0
@export var max_distance: float = 100.0
@export_flags_3d_physics var collide_with: int = 0xFFFFFFFF
@export var disable_flyby_detect : bool = false

var fly_direction: Vector3
var prev_pos: Vector3 = Vector3()

var hit_something : bool = false

var min_ricochet_angle: float = 45.0
var ricochets_left: int = 0
var pierces_left: int = 0

var distance_travelled: float = 0



func _ready() -> void:
	fly_direction = global_transform.basis.z
	prev_pos = global_transform.origin
	


func _process(delta: float) -> void:
	var new_pos: Vector3 = global_transform.origin - (fly_direction * speed * delta)
	
	var ray_query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(prev_pos, new_pos, collide_with)
	var result: Dictionary = get_world_3d().direct_space_state.intersect_ray(ray_query)
	
	#NOTE: Bullet detected a hit
	if not result.is_empty():
		#Extract dictionary info
		var collider: Node = result.collider 
		var collision_point: Vector3 = result.position
		
		hit_something = true
		
		#An entity was hit
		if collider is Entity: 
			_handle_entity_hit(collider)
		#Something else was hit
		else:
			_handle_static_hit(result)
		
		
	
	distance_travelled += prev_pos.distance_to(new_pos)
	if distance_travelled >= max_distance: destroy()
	
	
	global_transform.origin = new_pos
	prev_pos = new_pos
	


func destroy() -> void:
	queue_free()


func _handle_entity_hit(hit_entity: Entity) -> void:
	if hit_entity.health.is_dead(): return
	
	if damage_registry: hit_entity.damage(damage_registry)
	printt("hit entity", damage_registry)
	
	#Piercing
	if pierces_left <= 0: destroy()
	pierces_left -= 1


func _handle_static_hit(collision_data: Dictionary) -> void:
	if ricochets_left <= 0: destroy()
	if distance_travelled < 0.75: destroy()
	if fly_direction.angle_to(collision_data.normal) < deg_to_rad(min_ricochet_angle): destroy()
	
	disable_flyby_detect = false
	fly_direction = fly_direction.bounce(collision_data.normal)
	ricochets_left -= 1
	look_at(global_transform.origin - fly_direction)
