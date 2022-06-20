extends Area2D

# TODO
#####################################################################
# Encapsulates a touch screen joystick
#####################################################################



var max_pos_length : float = 128.0



func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventScreenDrag:
		var new_pos_x : float = position.x + event.relative.x
		new_pos_x = clamp(new_pos_x, -max_pos_length, max_pos_length)
		
		var new_pos_y : float = position.y + event.relative.y
		new_pos_y = clamp(new_pos_y, -max_pos_length, max_pos_length)
		
		var new_pos : = Vector2(new_pos_x, new_pos_y)
		
		position = new_pos
		
		get_tree().set_input_as_handled()
		
	elif event is InputEventScreenTouch:
		if !event.pressed:
			position = Vector2.ZERO
			
			get_tree().set_input_as_handled()










