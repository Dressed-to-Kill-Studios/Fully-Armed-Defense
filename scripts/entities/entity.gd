extends CharacterBody3D
class_name Entity

@export var health: HealthComponent


func _ready() -> void:
	pass


func damage(damage_registry: DamageRegistry) -> void:
	assert(health, "No Health Componnet found.")
	
	health.damage(damage_registry)


func kill() -> void:
	queue_free()
