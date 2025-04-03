extends Entity
class_name Enemy

@export var money_per_damage: float = 1.0
@export var money_per_kill: float = 100.0

func damage(damage_registry: DamageRegistry) -> void:
	if damage_registry.inflictor is not Player: return
	
	var player: Player = damage_registry.inflictor
	var health_before: float = health.current_health
	
	super(damage_registry)  # Apply damage
	
	var damage_dealt: float = health_before - health.current_health
	player.money.add_money(damage_dealt * money_per_damage)


func kill(damage_registry: DamageRegistry) -> void:
	if damage_registry.inflictor is not Player:
		return
	
	var player: Player = damage_registry.inflictor
	player.money.add_money(money_per_kill)
	
	super(damage_registry)  # Call parent kill function
