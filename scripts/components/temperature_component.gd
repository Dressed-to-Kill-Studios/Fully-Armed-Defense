extends Node
class_name TemperatureComponent

signal overheated
signal ended_overheat

@export var can_gain_heat: bool = true
@export var can_lose_heat: bool = true
@export_range(0.0, 1500.0, 10.0, "or_greater") var max_temperature: float = 1500.0
@export_range(0.0, 100.0, 5.0, "or_greater") var base_temperature: float = 20.0
@export_range(50.0, 500.0, 5.0, "or_greater") var heat_loss_per_sec: float = 250.0
@export_range(0.0, 10.0, 0.5, "or_greater") var overheat_time_sec: float = 7.5

var current_temperature: float = base_temperature
var is_overheated: bool = false
var overheat_timer: Timer


func _ready() -> void:
	_create_overheat_timer()


func _process(delta: float) -> void:
	cool_down(delta)
	print(NumberUtilities.temperature(current_temperature))


func increase_heat(amount: float) -> void:
	if not can_gain_heat: return
	if is_overheated: return
	
	current_temperature += amount
	if current_temperature >= max_temperature: trigger_overheat()


func cool_down(delta: float) -> void:
	if not can_lose_heat: return
	if is_overheated: return
	
	current_temperature = maxf(base_temperature, current_temperature - heat_loss_per_sec * delta)


func trigger_overheat() -> void:
	current_temperature = max_temperature
	is_overheated = true
	#overheated_audio.play()
	overheat_timer.start(overheat_time_sec)
	overheated.emit()
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "current_temperature", base_temperature, overheat_time_sec)


func end_overheat() -> void:
	is_overheated = false
	ended_overheat.emit()


func _create_overheat_timer() -> void:
	var timer: Timer = Timer.new()
	
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = overheat_time_sec
	timer.timeout.connect(end_overheat)
	
	add_child(timer)
	overheat_timer = timer
