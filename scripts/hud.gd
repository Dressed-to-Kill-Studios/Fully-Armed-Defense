extends CanvasLayer

@onready var health_label: Label = %HealthLabel


func _process(delta: float) -> void:
	pass


func update_health_label(current_health: float, max_health: float) -> void:
	var health_percentage: float = current_health / max_health
	var health_state: String = ""
	
	if health_percentage <= 0.2: health_state = "Critical"
	elif health_percentage <= 0.4: health_state = "Weakened"
	elif health_percentage <= 0.6: health_state = "Hurt"
	elif health_percentage <= 0.8: health_state = "Stable"
	else: health_state = "Optimal"
	
	health_label.text = "Health: %s" % health_state
