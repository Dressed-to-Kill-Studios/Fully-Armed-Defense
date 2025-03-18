extends Node
class_name ShootingComponent 

@export var can_shoot: bool = true
@export var firing_data: FiringData
@export var firing_point: Marker3D
@export var view_cast: RayCast3D
@export var fire_cast: RayCast3D
@export var clearance_origin: Node3D
@export var view_hit_point_threshold: float = 1.0

var cleared_to_shoot: bool = true

var global_point_bullet_will_hit: Vector3

var burst_shots_remaining: int = 0

var burst_time: float = 0.0
var fire_rate_time: float = 0.0


func _process(delta: float) -> void:
	burst_time = max(0.0, burst_time - delta)
	fire_rate_time = max(0.0, fire_rate_time - delta)
	
	_calculate_global_fire_position()
	_check_clearance()


func _physics_process(delta: float) -> void:
	_handle_burst()


func shoot() -> void:
	if not can_shoot: return
	if not cleared_to_shoot: return
	if not firing_data:
		printerr("No firing data assigned. - %s" % get_parent())
		return
	if fire_rate_time > 0.0: return
	
	fire_rate_time = 60.0 / firing_data.bullets_per_min
	
	if firing_data.firing_mode == FiringData.FIRING_MODES.BURST:
		burst_shots_remaining = firing_data.burst_amount
		return
	
	_fire_bullet() 
	


func _handle_burst() -> void:
	if burst_shots_remaining <= 0: return
	if burst_time > 0.0: return
	
	burst_shots_remaining -= 1
	_fire_bullet()
	
	burst_time = (60.0 / firing_data.bullets_per_min) / firing_data.burst_amount
	


func _fire_bullet() -> void:
	var bullet_instance: Bullet = firing_data.bullet_scene.instantiate()
	
	#NOTE:Additional bullet logic is going to go here later
	bullet_instance.damage_registry = firing_data.bullet_damage_registry
	bullet_instance.speed = firing_data.bullet_speed
	bullet_instance.pierces_left = firing_data.bullet_pierces
	
	firing_point.add_child(bullet_instance)
	bullet_instance.top_level = true


func _calculate_global_fire_position() -> void:
	var view_hit_point: Vector3 = view_cast.get_collision_point() if view_cast.is_colliding() \
		else view_cast.to_global(view_cast.target_position)
	
	var fire_target: Vector3 = fire_cast.to_local(view_hit_point)
	if view_cast.global_position.distance_to(view_hit_point) <= view_hit_point_threshold: fire_target = Vector3.FORWARD * 100
	
	fire_cast.target_position = fire_target
	global_point_bullet_will_hit = fire_cast.get_collision_point() if fire_cast.is_colliding() else view_hit_point
	firing_point.look_at(global_point_bullet_will_hit)


func _check_clearance() -> void:
	var ray_quary: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		clearance_origin.global_position, 
		firing_point.global_position)
	var result: Dictionary = clearance_origin.get_world_3d().direct_space_state.intersect_ray(ray_quary)
	
	cleared_to_shoot = result.is_empty()
	
