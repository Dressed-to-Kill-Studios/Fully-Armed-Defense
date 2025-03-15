extends Node
class_name HealthComponent 

signal health_changed(current_health: int)
signal health_depleted

@export var max_health: float = 100.0

var current_health: float = max_health


func _ready() -> void:
	pass


func damage(damage_registry: DamageRegistry) -> void:
	current_health -= damage_registry.damage_amount
	current_health = clampf(current_health, 0, max_health)
	
	health_changed.emit(current_health)
	
	if current_health == 0: health_depleted.emit()
