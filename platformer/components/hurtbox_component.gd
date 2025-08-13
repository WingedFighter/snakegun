class_name HurtboxComponent
extends Area2D

@export var healthComponent: HealthComponent
@export var iframe_timer: Timer

var iframe_time: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(take_damage)
	pass

func take_damage(damage: float) -> void:
	# Iframes are an optional component, cannot be damaged when there is no iframe timer associated.
	if iframe_timer != null:
		if iframe_timer.is_stopped():
			healthComponent.hurt(damage)
			iframe_timer.start(iframe_time)
	else:
		healthComponent.hurt(damage)
