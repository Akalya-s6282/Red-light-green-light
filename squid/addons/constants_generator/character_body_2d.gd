extends CharacterBody2D
#@onready var animated_sprite = $AnimatedSprite2D
#
#var speed = 200
#
#func _physics_process(delta):
	#if get_tree().paused:
		#return
#
	#var input_vector = Vector2(
		#Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		#Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#)
#
	#velocity = input_vector.normalized() * speed
	#move_and_slide()
	#if input_vector != Vector2.ZERO:
		#if not animated_sprite.is_playing():
			#animated_sprite.play("Walk")  # Replace "walk" with your animation name
		#else:
			#animated_sprite.stop()
