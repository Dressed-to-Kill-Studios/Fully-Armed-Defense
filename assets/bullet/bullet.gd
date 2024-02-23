extends Node3D
class_name Bullet

@export_group("Required Nodes")
@export var mesh : MeshInstance3D
@export var flyby_detection : Area3D
@export var light : OmniLight3D

@export_group("Bullet Hole")
@export var decal_bullet_hole : PackedScene

@export_group("Particle")
@export var particle_bullet_hit : PackedScene

@export_group("Sound")
@export var sound_bullet_hit : AudioStream
@export var sound_bullet_flyby : AudioStream
@export var sound_bullet_ricochet : AudioStream


var bullet_speed : float = 50
var bullet_damage : float = 0

var bullet_fly_direction : Vector3
var prev_pos : Vector3 = Vector3()

var total_distance : float = 0
var max_distance : float = 100

var is_hit : bool = false

var disable_flyby_detect : bool = false

#Ricochet
var bounces_left : int = 3
var can_bounce : bool = false
var min_bounce_angle : float = 45

var pierce_left : int = 3
var can_pierce : bool = false

var color : Color = Color.GOLD
var energy : float = 0.25

var life_time : float = 30


var player : CharacterBody3D


func _ready():
	assert(mesh, "No Bullet Mesh")
	assert(flyby_detection, "No Flyby Detection")
	assert(light, "No Omni Light")
	
	bullet_fly_direction = global_transform.basis.z
	prev_pos = global_transform.origin
	
	light.omni_range = energy * 100
	light.light_energy = energy
	light.light_color = color
	mesh.mesh.surface_get_material(0).albedo_color = color * 100
	
	flyby_detection.body_entered.connect(flyby_detection_body_entered)
	get_tree().create_timer(life_time).timeout.connect(destroy)


func _physics_process(delta):
	#New pos of bullet
	var new_pos : Vector3 = global_transform.origin - (bullet_fly_direction * bullet_speed * delta)
	
	global_transform.origin = new_pos
	
	
	#Cast ray from prev to new pos
	var query = PhysicsRayQueryParameters3D.create(prev_pos, new_pos)
	
	query.exclude = [self] if not player else [self, player]
	
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	
	if result:
		is_hit = true
		new_pos = result.position if not result.collider.is_in_group("Enemy") else new_pos
		
		if result.collider.has_method("damage"):
			result.collider.damage(bullet_damage)
		
		detect_surface(result)
		
		#Bounce
		if not result.collider.is_in_group("Enemy") and can_bounce:
			if bullet_fly_direction.angle_to(result.normal) >= deg_to_rad(min_bounce_angle) \
			and bounces_left > 0 and total_distance > 0.75:
				bullet_fly_direction = bullet_fly_direction.bounce(result.normal)
				bounces_left -= 1
				look_at(global_transform.origin - bullet_fly_direction, Vector3(1, 1, 0))
				#FIXME spawn_sound_at_position()
			else:
				destroy()
		#Pierce
		elif result.collider.is_in_group("Enemy") and can_pierce:
			if pierce_left > 0:
				pierce_left -= 1
			else:
				destroy()
		
		else: #Didnt pierce or bounce
			destroy()
	
	#
	total_distance += prev_pos.distance_to(new_pos)
	
	#Next frame
	prev_pos = new_pos
	
	#Max distance reached
	if total_distance >= max_distance: destroy()


func destroy():
	queue_free()


func detect_surface(result : Dictionary):
	pass


func spawn_sound_at_position(owner : Node, positiuon : Vector3, sound : AudioStream):
	pass


func spawn_bullet_hole_at_position(result : Dictionary, hole : PackedScene):
	pass


func spawn_particle_at_position(result : Dictionary, particlescene : PackedScene):
	pass


func flyby_detection_body_entered(body : Node3D):
	pass