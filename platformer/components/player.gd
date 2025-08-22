extends CharacterBody2D

@export var velocity_component: VelocityComponent
@export var shoot_component: ShootComponent
@export var health_component: HealthComponent
@export var animation_tree: AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

@export var horizontal_speed: float = 100
@export var vertical_speed: float = 10
@export var max_velocity: float = 1000
@export var gravity: float = 980.0
@export var jump_speed: float = -500
var facing: Vector2 = Vector2(1, 0)
var jumping: bool = false
var falling: bool = false

func _ready() -> void:
	health_component.health_depleted.connect(hurt)
	animation_tree.set("parameters/Walk/blend_position", 1)
	animation_tree.set("parameters/Idle/blend_position", 1)
	animation_tree.set("parameters/Jump/blend_position", 1)
	animation_tree.set("parameters/Fall/blend_position", 1)
	animation_tree.set("parameters/Dash/blend_position", 1)

func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	velocity.x = Input.get_axis("move_left", "move_right")
	if (velocity.x != 0):
		facing.x = velocity.x
		shoot_component.transform.x = transform.x * facing.x
		animation_tree.set("parameters/Walk/blend_position", facing.x)
		animation_tree.set("parameters/Idle/blend_position", facing.x)
		animation_tree.set("parameters/Jump/blend_position", facing.x)
		animation_tree.set("parameters/Fall/blend_position", facing.x)
		animation_tree.set("parameters/Dash/blend_position", facing.x)

	velocity.x *= horizontal_speed
	
	if !is_on_floor() and gravity != 0.0:
		velocity.y += gravity * delta
	
	clamp(velocity.x, -max_velocity, max_velocity)
	clamp(velocity.y, -max_velocity, max_velocity)
	
	if Input.is_action_just_pressed("normal_fire"):
		shoot_component.fire(facing * 1000, 1)

	jumping = !is_on_floor()
	falling = !is_on_floor() && velocity.y > 0

	move_and_slide()

func hurt() -> void:
	print_debug("player hurt")
