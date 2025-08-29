extends CanvasLayer

@export var health_component: HealthComponent
@export var player: PlayerMegaman
@onready var layer1 = $"Health Container"
@onready var layer2 = $"Health Container2"
@onready var exp_bar: AnimatedSprite2D = $GunLevel/ExpBar
@onready var gun_sprite: AnimatedSprite2D = $GunLevel/GunSprite

var hearts: Array[TextureRect]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.health_changed.connect(update_healthbar)
	for child in layer1.get_children():
		hearts.append(child)
	for child in layer2.get_children():
		hearts.append(child)
	update_healthbar(0, health_component.current_health)
	update_gun_level(4)

func update_healthbar(_old: int, new:int ) -> void:
	var i: int = 0
	for heart in hearts:
		if i < new:
			heart.visible = true
		else:
			heart.visible = false
		i += 1
	pass

func update_gun_level(new: int) -> void:
	exp_bar.frame = clampi(new, 0, 15)
	gun_sprite.frame = new / 5 + 1
