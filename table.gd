extends Node2D

var card_scene: PackedScene
var termite_scene: PackedScene
var assets_paths = {
		"larva": "res://assets/larva.png",
		"wood": "res://assets/wood.png",
		"soil": "res://assets/soil.png",
		"water": "res://assets/water.png",
		"cold": "res://assets/cold.png"
	}
var _table = {
	"targets": {
		"wood": 999,
		"soil": 999,
		"water": 999,
		"cold": 999
	},
	"current_resources": {
		"wood": 0,
		"soil": 0,
		"water": 0,
		"cold": 0
	},
	"larvae_number": 0,
	"worker_number": 6,
	"soldier_number": 2,
	"termite_species": false,
	"termite_species_name": "",
	"draw": 0
}
var player = _table.duplicate(true)
var opponent = _table.duplicate(true)
	
# Preload card scene only once
func _ready() -> void:
	card_scene = preload("res://card.tscn")
	termite_scene = preload("res://termite.tscn")
	player["node"] = "player"
	opponent["node"] = "opponent"
	
func _process(delta: float) -> void:
	_update_termite(player)
	_update_target(player)
	_update_termite(opponent)
	_update_target(opponent)
	if player["larvae_number"] == 0 and player["worker_number"] == 0 and player["soldier_number"] == 0:
		$win.text = "Your colony has been eliminated!"
	if opponent["larvae_number"] == 0 and opponent["worker_number"] == 0 and opponent["soldier_number"] == 0:
		$win.text = "Opponent colony eliminated!"

func _update_target(table: Dictionary) -> void:
	var node_to_update = get_node(table["node"])
	var target_table = node_to_update.get_node("target_table")
	var spawn = false
	if table.get("termite_species"):
		spawn = true
		
	# Remove all children from target_table
	for child in target_table.get_children():
		child.queue_free()
	
	for resource_name in table["targets"].keys():
		var target_value = table["targets"][resource_name]
		if target_value != 999:
			if table["current_resources"][resource_name] < target_value:
				spawn = false
			var resource_label = Label.new()
			resource_label.text = str(table["current_resources"][resource_name]) + "/" + str(target_value)
			resource_label.add_theme_color_override("font_color", Color(0, 0, 0))
			resource_label.add_theme_font_size_override("font_size", 30)
			target_table.add_child(resource_label)
			
			var resource_texture_rect = TextureRect.new()
			var resource_texture = load(assets_paths[resource_name])
			resource_texture_rect.texture = resource_texture
			resource_texture_rect.set_custom_minimum_size(Vector2(30, 30))
			target_table.add_child(resource_texture_rect)
	
	if spawn == true:
		for resource_name in table["targets"].keys():
			var target_value = table["targets"][resource_name]
			if target_value != 999:
				table["current_resources"][resource_name] -= target_value
		table["larvae_number"] += 1

# Function to handle drawing cards
func _on_draw_card_pressed(table: Dictionary) -> void:
	var player_turn = false
	var node_to_update = get_node(table["node"])
	if table["node"] == "player":
		player_turn = true
	var species = node_to_update.get_node("species")
	var draw_card_node = node_to_update.get_node("draw_card")
	var hint = node_to_update.get_node("hint")
	var use = node_to_update.get_node("use")
	var hold = node_to_update.get_node("hold")
	var on_table = node_to_update.get_node("on_table")
	var player_hand = node_to_update.get_node("player_hand")
	# In case the player does not hold species card
	if table["termite_species"] == false:
		var species_name = Values.get_species_name()
		table["termite_species_name"] = species_name
		var species_data = Values.species.get(species_name)
		var resource_data = species_data.get("resource")
		# Update the image of the card content node
		var asset_path = "res://assets/" + species_name + ".png"
		var texture = load(asset_path)
		var card_instance = card_scene.instantiate()
		# Connect hover signals
		card_instance.connect("mouse_entered", Callable(self, "_on_card_hovered").bind(card_instance))
		card_instance.connect("mouse_exited", Callable(self, "_on_card_unhovered").bind(card_instance))
		card_instance.get_node("card_content/image").texture = texture
		# Update the name of the card content node
		card_instance.get_node("card_content/top/name").text = species_data.get("name_cn")
		# Update the description of the card content node
		card_instance.get_node("card_content/description").text = species_data.get("description_cn")
		card_instance.get_node("card_content/description").add_theme_font_size_override("font_size", 36)	
		# Update the resource of required to win
		var resource_container = card_instance.get_node("card_content/top/resources")	
		for r in resource_data:
			var value = resource_data.get(r)
			if value > 0:
				table["targets"][r] = value
				var resource_label = Label.new()
				resource_label.text = str(value)  # Assuming resource_data contains meaningful information
				# Change the text color to black
				resource_label.add_theme_color_override("font_color", Color(0, 0, 0))
				resource_label.add_theme_font_size_override("font_size", 36)
				resource_container.add_child(resource_label)  # Adds the Label to the container
				# Add a TextureRect for the resource image (if required)
				var resource_texture_rect = TextureRect.new()
				var resource_asset_path = "res://assets/" + r + ".png"
				var resource_texture = load(resource_asset_path)
				resource_texture_rect.texture = resource_texture  # Reuse the previously loaded texture, or load a separate texture if needed
				# Make the TextureRect smaller
				resource_texture_rect.set_custom_minimum_size(Vector2(28, 28))
				resource_container.add_child(resource_texture_rect)  # Adds the TextureRect to the container
		# Add the card to the player's species table
		species.add_child(card_instance)
		table["termite_species"] = true
		draw_card_node.text = '確認'
		hint.text = '請左鍵點擊想使用的卡牌，或以右鍵點擊想保留至下回合的卡牌，然後點擊確認。'
		_on_draw_card_pressed(table)
		_on_draw_card_pressed(opponent)
		
	# In case the player holds species card	
	else:
		var draw_card = false
		# Use card
		if use.get_child_count() == 1:
			draw_card = true
			var card_to_use = use.get_child(0)
			# Get the first child node name under the "type" node
			var type_node = card_to_use.get_node("type")
			var first_child_name_type = type_node.get_children()[0].get_name()
			# Get the first child node name under the "name" node
			var name_node = card_to_use.get_node("name")
			var first_child_name_name = name_node.get_children()[0].get_name()
			# Get data
			var card_data = Values[first_child_name_type][first_child_name_name]
			var card_name = card_data.get("name_cn")
			var card_effects = card_data.get("effects")
			for e in card_effects:
				var _table_self = {}
				var _table_to_affect = {}
				var raid = false
				# To determine which table to affect
				var target = card_effects[e].get("target")
				if target == "opponent":
					if table["node"] == "player":
						_table_self = player
						_table_to_affect = opponent
					else:
						_table_self = opponent
						_table_to_affect = player
					if _table_self["soldier_number"] > _table_to_affect["soldier_number"]:
						raid = true
				else:
					if table["node"] == "player":
						_table_self = player
						_table_to_affect = player
					else:
						_table_self = opponent
						_table_to_affect = opponent
				
				if _table_to_affect != {}:
					# Species filter
					var filter = card_effects[e].get("filter")
					if _table_to_affect["termite_species_name"] in filter:
						var _to_effect = true
						var condition = card_effects[e].get("condition")
						if condition == "lower_soldier_number":
							if player["soldier_number"] > opponent["soldier_number"]:
								_table_to_affect = opponent
							elif opponent["soldier_number"] > player["soldier_number"]:
								_table_to_affect = player
							else:
								_to_effect = false
						if _to_effect == true:
							# To determine the type of effect
							var effect_type = card_effects[e].get("type")
							# Subcategory: Reource or Caste
							var select = card_effects[e].get("select")
							# Scale of impact
							var value = card_effects[e].get("value")
							# Resource card
							if effect_type == "gain_resource":
								_table_to_affect["current_resources"][select] += value
							# Spawn larvae
							elif effect_type == "spawn":
								_table_to_affect["larvae_number"] += value
							# Draw a card
							elif effect_type == "draw":
								_table_to_affect["draw"] += value
							# Regressive molting
							elif effect_type == "reset_caste":
								for t in range(value):
									if _table_to_affect["worker_number"] > 1:
										_table_to_affect["worker_number"] -= 1
										_table_to_affect["larvae_number"] += 1
									
									if _table_to_affect["soldier_number"] > 1:
										_table_to_affect["soldier_number"] -= 1
										_table_to_affect["larvae_number"] += 1
										
							# Remove resource
							elif effect_type == "remove_resource":
								_table_to_affect["current_resources"][select] -= value
								if _table_to_affect["current_resources"][select] < 0:
									_table_to_affect["current_resources"][select] = 0
							
							# Raid resource
							elif effect_type == "raid_resource":
								if raid == true:
									# Ensure the value being stolen is not greater than what the opponent has
									var stolen_value = min(value, _table_to_affect["current_resources"].get(select, 0))
									_table_to_affect["current_resources"][select] -= stolen_value
									if _table_to_affect["current_resources"][select] < 0:
										_table_to_affect["current_resources"][select] = 0
									
									_table_self["current_resources"][select] += stolen_value
									if _table_self["current_resources"][select] < 0:
										_table_self["current_resources"][select] = 0
									
							# Remove termite
							elif effect_type == "remove_termite":
								_table_to_affect[select] -= value
								if _table_to_affect[select] < 0:
									_table_to_affect[select] = 0
					
			use.remove_child(card_to_use)
			on_table.add_child(card_to_use)

			# Clear cards on hand
			for child in player_hand.get_children():
				child.queue_free()
				
			# Organize the table
			if on_table.get_child_count() > 15:
				# Remove the oldest child (the first child)
				var oldest_child = on_table.get_child(0)
				on_table.remove_child(oldest_child)
				oldest_child.queue_free()
				
			hint.text = '您使用了 "' + card_name + '"。'
	
		else:
			var cards_in_hand = player_hand.get_child_count()
			if cards_in_hand == 0:
				draw_card = true
			else:
				# Generate a random index between 0 and cards_in_hand - 1
				var random_index = randi() % cards_in_hand
				var random_card = player_hand.get_child(random_index)
				player_hand.remove_child(random_card)
				random_card.disconnect("gui_input", Callable(self, "_on_card_pressed").bind(random_card))
				random_card.disconnect("mouse_entered", Callable(self, "_on_card_hovered").bind(random_card))
				random_card.disconnect("mouse_exited", Callable(self, "_on_card_unhovered").bind(random_card))
				use.add_child(random_card)
				hint.text = '您忘了選擇要使用的卡片，系統已為您逢機選擇。'
				
		if draw_card == true:
			if player_turn:
				_on_draw_card_pressed(opponent)
				_on_draw_card_pressed(opponent)
				# Randomly decide to hatch a worker or a soldier
				randomize()  # Ensure random seed is set
				var random_choice = randi() % 2  # Generate 0 or 1
				if random_choice == 0:
					hatch_worker_pressed(opponent)
				else:
					hatch_soldier_pressed(opponent)
			# draw cards
			var cards = 1 + ceil(table["worker_number"] / 4.0) + table["draw"]
			table["draw"] = 0
			for card in range(cards):
				var card_instance = card_scene.instantiate()
				# Connect hover signals
				card_instance.connect("mouse_entered", Callable(self, "_on_card_hovered").bind(card_instance))
				card_instance.connect("mouse_exited", Callable(self, "_on_card_unhovered").bind(card_instance))
				var card_type = null
				var card_data = null
				var card_name = null
				
				randomize()
				var rand_value = randf() * 100
				# Determine the card type based on probabilities
				if rand_value <= 45.8:
					card_type = "resource"
					card_name = Values.get_resource_name()
					card_data = Values.resource.get(card_name)
				elif rand_value <= 45.8 + 20.8: # 45.8% + 20.8% = 66.6%
					card_type = "disaster"
					card_name = Values.get_disaster_name()
					card_data = Values.disaster.get(card_name)
				else:
					card_type = "event"
					card_name = Values.get_event_name()
					card_data = Values.event.get(card_name)
						
				# Save data to card
				var card_owner_node = Node.new()
				card_owner_node.set_name(table["node"])
				card_instance.get_node("owner").add_child(card_owner_node)
				var card_type_node = Node.new()
				card_type_node.set_name(card_type)
				card_instance.get_node("type").add_child(card_type_node)
				var card_name_node = Node.new()
				card_name_node.set_name(card_name)
				card_instance.get_node("name").add_child(card_name_node)
						
				# Update the name of the card content node
				card_instance.get_node("card_content/top/name").text = card_data.get("name_cn")
						
				# Update the image of the card content node
				var asset_path = "res://assets/" + card_name + ".png"
				var texture = load(asset_path)
				card_instance.get_node("card_content/image").texture = texture
						
				# Update the description of the card content node
				card_instance.get_node("card_content/description").text = card_data.get("description_cn")
				card_instance.get_node("card_content/description").add_theme_font_size_override("font_size", 36)
						
				# Add the card to the player's hand
				player_hand.add_child(card_instance)

				# Connect to detect mouse press
				card_instance.connect("gui_input", Callable(self, "_on_card_pressed").bind(card_instance))
						
				# Dynamically adjust hseparation based on number of cards
				adjust_card_spacing(table)

# Function to adjust card spacing dynamically
func adjust_card_spacing(table: Dictionary) -> void:
	var node_to_update = get_node(table["node"])
	var player_hand = node_to_update.get_node("player_hand")
	var separation = 0
	var screen_width = 1000
	var card_width = 153.6
	var card_count = player_hand.get_child_count()
	var total_card_width = card_count * card_width

	# Calculate overlap based on the available screen width
	var available_width = screen_width - 153.6  # Leave some padding, e.g. 100 pixels
	if total_card_width > available_width:
		separation = -3.4*(total_card_width - available_width) / card_count
	
	# Apply the calculated separation to card hand
	player_hand.add_theme_constant_override("separation", separation)

# Function to handle the mouse hover over a card
func _on_card_hovered(card_instance: Node) -> void:
	# Bring the card to the top by increasing z-index
	card_instance.z_index = 100
	card_instance.scale = Vector2(1.6, 1.6)
	
# Function to handle when the mouse leaves the card
func _on_card_unhovered(card_instance: Node) -> void:
	# Reset the z-index of the card
	card_instance.z_index = 0
	card_instance.scale = Vector2(1.0, 1.0)

# Function to handle when a card is pressed
func _on_card_pressed(event: InputEvent, card_instance: Control) -> void:
	# Get the first child node name under the "owner" node
	var owner_node = card_instance.get_node("owner")
	var first_child_name_owner = owner_node.get_children()[0].get_name()
	if first_child_name_owner == "player":
		# Get the first child node name under the "type" node
		var type_node = card_instance.get_node("type")
		var first_child_name_type = type_node.get_children()[0].get_name()
		# Get the first child node name under the "name" node
		var name_node = card_instance.get_node("name")
		var first_child_name_name = name_node.get_children()[0].get_name()
		var card_data = Values[first_child_name_type][first_child_name_name]
		var card_name = card_data.get("name_cn")
		var node_to_update = get_node(str(first_child_name_owner))
		var player_hand = node_to_update.get_node("player_hand")
		var hint = node_to_update.get_node("hint")
		var use = node_to_update.get_node("use")
		var hold = node_to_update.get_node("hold")
		var on_table = node_to_update.get_node("on_table")
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			player_hand.remove_child(card_instance)
			card_instance.disconnect("gui_input", Callable(self, "_on_card_pressed").bind(card_instance))
			card_instance.disconnect("mouse_entered", Callable(self, "_on_card_hovered").bind(card_instance))
			card_instance.disconnect("mouse_exited", Callable(self, "_on_card_unhovered").bind(card_instance))
			hold.add_child(card_instance)
			if hold.get_child_count() > 1:
				var oldest_child = hold.get_child(0)
				hold.remove_child(oldest_child)
				player_hand.add_child(oldest_child)
				oldest_child.connect("gui_input", Callable(self, "_on_card_pressed").bind(oldest_child))
				oldest_child.connect("mouse_entered", Callable(self, "_on_card_hovered").bind(oldest_child))
				oldest_child.connect("mouse_exited", Callable(self, "_on_card_unhovered").bind(oldest_child))
			hint.text = '你即將保留 "' + card_name + '"。'
				
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			player_hand.remove_child(card_instance)
			card_instance.disconnect("gui_input", Callable(self, "_on_card_pressed").bind(card_instance))
			card_instance.disconnect("mouse_entered", Callable(self, "_on_card_hovered").bind(card_instance))
			card_instance.disconnect("mouse_exited", Callable(self, "_on_card_unhovered").bind(card_instance))
			use.add_child(card_instance)
			if use.get_child_count() > 1:
				var oldest_child = use.get_child(0)
				use.remove_child(oldest_child)
				player_hand.add_child(oldest_child)
				oldest_child.connect("gui_input", Callable(self, "_on_card_pressed").bind(oldest_child))
				oldest_child.connect("mouse_entered", Callable(self, "_on_card_hovered").bind(oldest_child))
				oldest_child.connect("mouse_exited", Callable(self, "_on_card_unhovered").bind(oldest_child))
			hint.text = '你即將使用 "' + card_name + '"。'
		
func _update_termite(table: Dictionary):
	var node_to_update = get_node(table["node"])
	var larvae = node_to_update.get_node("larvae")
	var worker = node_to_update.get_node("worker")
	var soldier = node_to_update.get_node("soldier")
	var larvae_number = node_to_update.get_node("larvae_number")
	var worker_number = node_to_update.get_node("worker_number")
	var soldier_number = node_to_update.get_node("soldier_number")
	# Clear all children under $the_anchor/larvae,worker,soldier
	for child in larvae.get_children():
		child.queue_free()
	for child in worker.get_children():
		child.queue_free()
	for child in soldier.get_children():
		child.queue_free()
	
	larvae_number.text = " x" + str(table["larvae_number"])
	worker_number.text = " x" + str(table["worker_number"])
	soldier_number.text = " x" + str(table["soldier_number"])
	
	# Spawn the required number of termites
	var adjusted_larvae_number = min(table["larvae_number"], 13)
	var adjusted_worker_number = min(table["worker_number"], 13)
	var adjusted_soldier_number = min(table["soldier_number"], 13)
	
	for l in range(adjusted_larvae_number):
		var larvae_texture_rect = TextureRect.new()
		var larvae_texture = load(assets_paths["larva"])
		larvae_texture_rect.texture = larvae_texture
		larvae.add_child(larvae_texture_rect)
	
	for w in range(adjusted_worker_number):
		var worker_texture_rect = TextureRect.new()
		var worker_texture = load("res://assets/" + table["termite_species_name"] + "_worker.png")
		worker_texture_rect.texture = worker_texture
		worker.add_child(worker_texture_rect)
	
	for s in range(adjusted_soldier_number):
		var soldier_texture_rect = TextureRect.new()
		var soldier_texture = load("res://assets/" + table["termite_species_name"] + "_soldier.png")
		soldier_texture_rect.texture = soldier_texture
		soldier.add_child(soldier_texture_rect)

func hatch_worker_pressed(table: Dictionary) -> void:
	if table["termite_species"]:
		if table["larvae_number"] > 0:
			table["larvae_number"] -= 1
			table["worker_number"] += 1

func _on_player_hatch_worker_pressed() -> void:
	hatch_worker_pressed(player)

func hatch_soldier_pressed(table: Dictionary) -> void:
	if table["termite_species"]:
		if table["larvae_number"] > 0:
			table["larvae_number"] -= 1
			table["soldier_number"] += 1

func _on_player_hatch_soldier_pressed() -> void:
	hatch_soldier_pressed(player)
	
func _on_player_start() -> void:
	_on_draw_card_pressed(player)
