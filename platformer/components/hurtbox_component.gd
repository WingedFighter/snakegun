class_name HurtboxComponent
extends Area2D

@export var healthComponent: HealthComponent
@export var iframe_timer: Timer
# Set this to determine which collisions get detected, similar to layers, but this is to avoid self collion ie enemy hitboxes on hurtboxes
# 0 - Player interactions
# 1 - Enemy interactions
# For example, Players have hitbox_source_layer set to 0 to assign bullets their hitbox, which means enemy hurtboxes must be set to 0 for them to interact
# For example, Enemies have hitbox_source_layer set to 1 to assign the area2D damage, which means enemy hurtboxes must be set to 1 for them to interact
# This is kind of a shitty solution since I didn't want to use more layers lol
@export var layer_filter: int = 0

var iframe_time: float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(take_damage)
	pass

func take_damage(area: Area2D) -> void:
	if area.get_parent() is Bullet:
		var bullet: Bullet = area.get_parent()
		if bullet.hitbox_source_layer != layer_filter:
			return
		# Iframes are an optional component, cannot be damaged when there is no iframe timer associated.
		if iframe_timer != null:
			if iframe_timer.is_stopped():
				healthComponent.hurt(bullet.damage)
				iframe_timer.start(iframe_time)
		else:
			healthComponent.hurt(bullet.damage)
	if area.get_parent() is Enemy:
		var enemy: Enemy = area.get_parent()
		if enemy.hitbox_source_layer != layer_filter:
			return
		if iframe_timer != null:
			if iframe_timer.is_stopped:
				healthComponent.hurt(enemy.damage)
		else:
			healthComponent.hurt(enemy.damage)
		
