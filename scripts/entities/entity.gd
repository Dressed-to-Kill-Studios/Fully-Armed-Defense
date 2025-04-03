extends CharacterBody3D
class_name Entity

@export var health: HealthComponent


func _ready() -> void:
	health.health_depleted.connect(kill)


func damage(damage_registry: DamageRegistry) -> void:
	assert(health, "No Health Componnet found.")
	
	health.damage(damage_registry)


func kill(damage_registry: DamageRegistry) -> void:
	printt("%s was killed" % self)
	queue_free()
