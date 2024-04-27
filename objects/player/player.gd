extends CharacterBody3D

@export var SPEED: float = 2.0 
@export var SPRINT_MULTIPLIER: float = 2.0

@export var CAMERA_SENSITIVITY: float = 0.1

@onready var gameNode = get_node("/root/Game")

var gravity = Vector3(0, -1, 0)
var alignedTransform = Transform3D()

var mouse = Vector2()

func alignY(transformVar, new_y) -> Transform3D:
	var newTransform = transformVar
	newTransform.basis.y = new_y
	newTransform.basis.x = -newTransform.basis.z.cross(new_y)
	newTransform.basis = newTransform.basis.orthonormalized()
	return newTransform

func getGravityUP() -> Vector3:
	return  -gravity.normalized()

func _ready():
	if gameNode.paused == false:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	gameNode.pause_game.connect(pause_game)

func pause_game(pause):
	if pause == true:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func  _input(event):
	if event is InputEventMouseMotion and gameNode.paused == false:
		mouse.x += -event.relative.x * CAMERA_SENSITIVITY
		mouse.y = clamp(-event.relative.y * CAMERA_SENSITIVITY + mouse.y, -89, 89)
		$CameraGimbal.rotation_degrees.x = mouse.y

func _process(delta):
	if gameNode.paused == false:
		gravity = Vector3(0, 0, 0) - transform.origin

		alignedTransform.basis = alignedTransform.basis.orthonormalized().slerp(alignY(alignedTransform, getGravityUP()).basis, delta * 16)
		rotation = alignedTransform.basis.get_euler()
		rotate_object_local(Vector3(0,1,0), deg_to_rad(mouse.x))

		var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_forward", "move_backward")).normalized()
		direction *= SPEED
		if Input.is_action_pressed("sprint") == true:
			direction *= SPRINT_MULTIPLIER
		velocity = transform.basis * Vector3(direction.x, 0, direction.y)
		velocity += gravity / 10
		move_and_slide()
