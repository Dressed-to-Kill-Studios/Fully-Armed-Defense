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

@export var bullet_scene: PackedScene = preload("res://prefabs/bullets/test_bullet.tscn")
