extends Resource
class_name FiringData

enum FIRING_MODES {
	SEMI_AUTO,
	BURST,
	AUTO,
}

@export var firing_mode: FIRING_MODES = FIRING_MODES.SEMI_AUTO
@export var burst_amount: int = 3
@export var bullets_per_min: int = 60

@export_group("Bullet Settings")
@export var bullet_damage_registry: DamageRegistry = DamageRegistry.new()
@export_range(0, 1000, 1, "or_greater") var bullet_speed: float = 50.0
@export_range(0, 10, 1, "or_greater") var bullet_pierces: int = 0;
@export_range(0, 10, 1, "or_greater") var bullet_ricochets: int = 0;
@export_range(0, 90, 0.5) var bullet_min_ricochet_angle: int = 45;
@export var bullet_scene: PackedScene = preload("res://prefabs/bullets/test_bullet.tscn")
