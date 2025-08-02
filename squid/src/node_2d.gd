extends Node2D

@onready var player = $Player
@onready var label = $Label
@onready var timer = $Timer
@onready var anim = $Player/AnimatedSprite2D  # ✅ direct and safe
@onready var static_body_2d: StaticBody2D = $StaticBody2D

var move_timer := 0.0

var udp := PacketPeerUDP.new()
var move_requested := false

var is_green_light = true
var movement_threshold = 2
var last_position = Vector2.ZERO

func _ready():
	start_game()
	var bind_result = udp.bind(8000) 
	anim.play("walk") # ✅ Correct way
	if bind_result != OK:
		print("❌ Failed to bind UDP port 8000")
	else:
		print("✅ Listening on UDP port 8000")

func start_game():
	label.text = "Green Light! Go!"
	is_green_light = true
	timer.wait_time = randf_range(2.0, 4.0)
	timer.start()
	last_position = player.position

func _on_Timer_timeout():
	is_green_light = !is_green_light
	if is_green_light:
		label.text = "Green Light! Go!"
	else:
		label.text = "Red Light! Don't Move!"
		last_position = player.position
	timer.wait_time = randf_range(2.0, 4.0)
	timer.start()

func _process(delta):
	# 🔁 Check for UDP packet
	# Check if new move message received
	while udp.get_available_packet_count() > 0:
		var msg = udp.get_packet().get_string_from_utf8().strip_edges()
		if msg == "MOVE":
			move_timer = 0.5  # keep moving for 0.5 seconds
			print("Received MOVE")

	# Decrease timer each frame
	if move_timer > 0:
		move_timer -= delta
		player.position.x += 10 * delta * 20   # consistent speed (frame-rate independent)

		if not anim.is_playing() or anim.animation != "walk":
			print("wak")
			anim.play("walk")
	else:
		if anim.is_playing():
			print("stop")
			anim.stop()


	# ❌ Eliminate if moved during red light
	if !is_green_light:
		var distance_moved = player.position.distance_to(last_position)
		if distance_moved > movement_threshold:
			label.text = "You Moved! Eliminated!"
			get_tree().paused = true
			
	if player.position.x >= 950 and is_green_light:
		label.text = "🎉 You Win!"
		get_tree().paused = true
		return
