extends AspectRatioContainer

func _on_forward_button_down() -> void:
	Input.action_press(&"move_forward")
func _on_forward_button_up() -> void:
	Input.action_release(&"move_forward")

func _on_back_button_down() -> void:
	Input.action_press(&"move_back")
func _on_back_button_up() -> void:
	Input.action_release(&"move_back")

func _on_left_button_down() -> void:
	Input.action_press(&"move_left")
func _on_left_button_up() -> void:
	Input.action_release(&"move_left")

func _on_right_button_down() -> void:
	Input.action_press(&"move_right")
func _on_right_button_up() -> void:
	Input.action_release(&"move_right")

func _on_jump_button_down() -> void:
	Input.action_press(&"jump")
func _on_jump_button_up() -> void:
	Input.action_release(&"jump")
