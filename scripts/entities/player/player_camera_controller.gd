extends Node
class_name PlayerCameraComponent 

@export var can_look: bool = true

var mouse_sensitivity: float = 0.003

@onready var head: Node3D = %Head
@onready var secondary_camera: Camera3D = %SecondaryCamera
@onready var primary_camera: Camera3D = %PrimaryCamera


#HACK: THIS IS A PLACE HOLDER CAMERA CONTROL SYSTEM, SMOOTHER VERSION NEEDS TO IMPLEMENTED
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not can_look: return
		
		owner.rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90)
	


func update_camera(delta: float) -> void:
	primary_camera.global_transform = head.global_transform
	
	secondary_camera.global_transform = primary_camera.global_transform
	secondary_camera.fov = primary_camera.fov
