extends CanvasLayer

@export var crosshair_position_threshold: float = 75.0
@export var crosshair_position_lerp_speed: float = 15.0

@onready var player_shooting: ShootingComponent = %PlayerShooting
@onready var player_health: HealthComponent = %HealthComponent

@onready var health_label: Label = %HealthLabel
@onready var cannot_shoot_crosshair: Node2D = %CannotShootCrosshair
@onready var static_crosshair: Node2D = %StaticCrosshair
@onready var crosshair: Node2D = %RealCrosshair


func _process(delta: float) -> void:
	if player_shooting: update_crosshairs(delta)
	if player_health: update_health_label()


func update_crosshairs(delta: float) -> void:
	#HACK
	
	if not player_shooting.can_shoot or not player_shooting.cleared_to_shoot:
		cannot_shoot_crosshair.show()
		static_crosshair.hide()
		crosshair.hide()
		return
	else:
		cannot_shoot_crosshair.hide()
		static_crosshair.show()
		crosshair.show()
	
	if not player_shooting.fire_cast.is_colliding(): 
		crosshair.modulate.a = 0
		crosshair.global_position = static_crosshair.global_position
		return
	
	var coliision_point: Vector3 = player_shooting.fire_cast.get_collision_point()
	var screen_pos: Vector2 = %BackupCam.unproject_position(coliision_point)
	var new_crosshair_position: Vector2 = screen_pos if screen_pos else static_crosshair.global_position
	
	crosshair.global_position = crosshair.global_position.lerp(new_crosshair_position, crosshair_position_lerp_speed * delta)
	
	var crosshair_threshold_ratio: float = static_crosshair.global_position.distance_to(crosshair.global_position) / crosshair_position_threshold
	var remapped_crosshair_ratio: float = remap(crosshair_threshold_ratio, 0, 1, -0.5, 1)
	crosshair.modulate.a = lerpf(0, 0.5, clampf(remapped_crosshair_ratio, 0, 1.0))
	


func update_health_label() -> void:
	var health_percentage: float = player_health.current_health / player_health.max_health
	var health_state: String = ""
	
	if health_percentage <= 0.2: health_state = "Critical"
	elif health_percentage <= 0.4: health_state = "Weakened"
	elif health_percentage <= 0.6: health_state = "Hurt"
	elif health_percentage <= 0.8: health_state = "Stable"
	else: health_state = "Optimal"
	
	health_label.text = "Health: %s" % health_state
