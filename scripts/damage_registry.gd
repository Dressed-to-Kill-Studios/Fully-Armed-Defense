extends Resource
class_name DamageRegistry

@export var inflictor: NodePath
@export var damage_amount: float = 0


func _init(_damage_amount: float, _inflictor: NodePath = "") -> void:
	inflictor = _inflictor
	damage_amount = _damage_amount
