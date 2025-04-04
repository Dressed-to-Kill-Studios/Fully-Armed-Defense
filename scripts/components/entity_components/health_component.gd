extends Node
class_name HealthComponent 

signal health_changed(current_health: float, max_health: float)
signal health_depleted(damage_registry: DamageRegistry)

@export var max_health: float = 100.0

var current_health: float = max_health


func _ready() -> void:
	await owner.ready 
	health_changed.emit(current_health, max_health)


func damage(damage_registry: DamageRegistry) -> void:
	current_health -= damage_registry.damage_amount
	current_health = clampf(current_health, 0, max_health)
	
	health_changed.emit(current_health, max_health)
	
	if current_health == 0: health_depleted.emit(damage_registry)


func is_dead() -> bool:
	return true if current_health <= 0 else false
