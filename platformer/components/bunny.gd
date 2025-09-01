extends Enemy

@export var gravity: float = 980.0
@export var jump_speed: float = -500
var jumping: bool = false

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 0:
			jumping = false
	else:
		jumping = true
		velocity.y = jump_speed
	move_and_slide()
