extends CharacterBody2D

@export var velocity_component: VelocityComponent

@export var horizontal_speed: float = 300
@export var vertical_speed: float = 10
@export var max_velocity: float = 1000
@export var gravity: float = 980.0
@export var jump_speed: float = -1000

func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = Input.get_axis("move_left", "move_right")
	velocity.x *= horizontal_speed
	
	if !is_on_floor() and gravity != 0.0:
		velocity.y += gravity * delta
	
	clamp(velocity.x, -max_velocity, max_velocity)
	clamp(velocity.y, -max_velocity, max_velocity)

	move_and_slide()
