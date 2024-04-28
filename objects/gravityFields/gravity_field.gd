extends Node3D

@export var GRAVITY = -9.8

@export var SHOW_HINT = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint() and not SHOW_HINT:
		get_node("EditorHint").queue_free()


func _on_area_3d_body_entered(body: Node3D):
	if body.is_in_group("GravityAffected"):
		body.gravity = -basis.y