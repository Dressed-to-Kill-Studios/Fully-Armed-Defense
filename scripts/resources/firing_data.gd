extends Resource
class_name FiringData

enum FIRING_MODES {
	SEMI_AUTO,
	BURST,
	AUTO,
}

@export var firing_mode: FIRING_MODES = FIRING_MODES.SEMI_AUTO
@export_range(0, 10, 1, "or_greater") var burst_amount: int = 3
@export_range(0.1, 5, 0.1, "or_greater") var burst_time_seconds: float = 0.5
@export_range(0, 2400, 1, "or_greater") var bullets_per_min: float = 60.0
@export_range(0, 500, 1, "or_greater") var heat_per_shot: float = 500.0

@export_group("Bullet Settings")
@export_range(0, 100, 0.1, "or_greater") var bullet_damage: float = 10.0
@export var bullet_knockback: float = 0.0
@export_range(0, 1000, 1, "or_greater") var bullet_speed: float = 50.0
@export_range(0, 10, 1, "or_greater") var bullet_pierces: int = 0;
@export_range(0, 10, 1, "or_greater") var bullet_ricochets: int = 0;
@export_range(0, 90, 0.5) var bullet_min_ricochet_angle: float = 45.0;
@export var bullet_scene: PackedScene = preload("res://prefabs/bullets/test_bullet.tscn")
