extends Enemy

@onready var health_component: HealthComponent = $HealthComponent
@onready var sprite: AnimatedSprite2D = $HitflashComponent/AnimatedSprite2D
@onready var timer: Timer = $DeathTimer
@onready var boss_explosion = $BossExplosion
@onready var animation_player = $AnimationPlayer
@onready var state_timer = $StateTimer
@export var player: PlayerMegaman

var direction: int = -1
var h_speed: int = 100
var gravity: float = 980.0
var jump_speed: float = -800

enum {
	dash,
	death,
	jump,
	fall,
	walk,
	idle
}

var state = idle

func _ready() -> void:
	health_component.health_depleted.connect(on_death)
	timer.autostart = false
	timer.one_shot = true
	timer.timeout.connect(scene_transition)
	boss_explosion.visible = false
	state_timer.timeout.connect(state_change)

func _physics_process(delta: float) -> void:
	match state:
		dash: dash_state()
		death: death_state()
		jump: jump_state(delta)
		fall: fall_state(delta)
		walk: walk_state()
		idle: idle_state()
	move_and_slide()

func dash_state():
	velocity.x = direction * h_speed * 2

func death_state():
	pass

func fall_state(delta: float):
	velocity.y += gravity * delta
	if is_on_floor():
		transition_state(idle)

func jump_state(delta: float):
	velocity.y += gravity * delta
	if velocity.y > 0:
		transition_state(fall)

func walk_state():
	velocity.x = direction * h_speed * 2

func idle_state():
	pass

func state_change() -> void:
	var choices = [
		dash,
		jump,
		walk,
		idle
	]
	if player.position.x < position.x:
		direction = -1
	else:
		direction = 1
	transition_state(choices[randi() % choices.size()])


# This acts as an initial setup function to avoid redundant animation checks so the physics step can focus on physics.
func transition_state(new_state) -> void:
	sprite.flip_h = direction == 1
	match new_state:
		dash:
			animation_player.play("dash")
			state = dash
			state_timer.start(2)
		death:
			animation_player.play("death")
			state = death
		jump:
			velocity.y = jump_speed
			animation_player.play("jump")
			state = jump
		fall:
			animation_player.play("fall")
			state = fall
		walk:
			animation_player.play("walk")
			state = walk
			state_timer.start(2)
		idle:
			animation_player.play("idle")
			state = idle
			state_timer.start(1)

func on_death() -> void:
	animation_player.play("death")
	boss_explosion.visible = true
	state_timer.paused = true
	timer.start(1)
	timer.paused = false

func scene_transition() -> void:
	SceneManager.change_scene("PostBoss2")
