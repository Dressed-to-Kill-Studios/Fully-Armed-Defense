extends Resource
class_name DamageRegistry

enum DAMAGE_TYPE {
	MELEE,
	BULLET,
	EXPLOSION,
}

var inflictor: Node
var damage_type: DAMAGE_TYPE
var damage_amount: float = 0
var is_critical: bool = false
var knockback_amount: float = 0
