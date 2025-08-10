class_name VelocityComponent
extends Node2D

@export var horizontal_speed: float = 10
@export var vertical_speed: float = 10
@export var max_velocity: float = 1000
@export var gravity: float = 980.0

func calculate_movement(velocity: Vector2, is_on_floor: bool, delta: float) -> Vector2:
	var new_velocity = velocity 
	
	if !is_on_floor and gravity != 0.0:
		new_velocity.y += gravity * delta

	new_velocity.x = velocity.x * horizontal_speed
	new_velocity.y = velocity.y * vertical_speed
	
	clamp(new_velocity.x, -max_velocity, max_velocity)
	clamp(new_velocity.y, -max_velocity, max_velocity)
	
	return new_velocity
