extends Label


var rising_speed = 10


func _process(delta):
	var position = get_global_transform().get_origin()
	position.y -= delta * rising_speed
	set_global_position(position)


func _on_Timer_timeout():
	queue_free()
