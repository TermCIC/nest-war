extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_button_pressed():
	# Load the new scene
	var new_scene = load("res://table.tscn")
	if new_scene:
		# Replace the current scene with the new one
		get_tree().root.get_child(0).queue_free()  # Remove the current scene
		get_tree().root.add_child(new_scene.instantiate())  # Add the new scene
		# Disable the entrance node
		if $entrance:
			$entrance.visible = false
