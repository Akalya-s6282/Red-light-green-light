extends Node2D
#@onready var player = $Player
#@onready var label = $Label
#@onready var timer = $Timer
#
#var is_green_light = true
#var movement_threshold = 2
#var last_position = Vector2.ZERO
#
#func _ready():
	#start_game()
	#
#func start_game():
	#label.text = "Green Light! Go!"
	#is_green_light = true
	#timer.wait_time = randf_range(2.0, 4.0)
	#timer.start()
	#last_position = player.position
#
#func _on_Timer_timeout():
	#is_green_light = !is_green_light
	#if is_green_light:
		#label.text = "Green Light! Go!"
	#else:
		#label.text = "Red Light! Don't Move!"
		#last_position = player.position
	#timer.wait_time = randf_range(2.0, 4.0)
	#timer.start()
#
#func _process(delta):
	#if !is_green_light:
		#var distance_moved = player.position.distance_to(last_position)
		#if distance_moved > movement_threshold:
			#label.text = "You Moved! Eliminated!"
			#get_tree().paused = true
