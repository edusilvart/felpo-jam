extends Button


@onready var name_label : Label = get_node('Name')
@onready var icon_tex : TextureRect = get_node('Icon')
@onready var description_label : Label = get_node('Description')
var waiting_selection : bool = false
var discarded_item01 : bool = false

signal selected
signal item_discarded

func _input(event: InputEvent) -> void:
	if waiting_selection:
		if event.is_action_pressed("item_01"):
			item_discarded.emit()
			discarded_item01 = true
		if event.is_action_pressed('item_02'):
			item_discarded.emit()
			discarded_item01 = false

func _on_pressed() -> void:
	var item_scene = load('res://items/' + name_label.text + '.tscn')
	var new_item = item_scene.instantiate()
	new_item.icon_tex = icon_tex.texture
	new_item.parent = Globals.player
	Globals.player.add_child(new_item)
	
	if Globals.player.item01 == null:
		Globals.player.item01 = new_item
	elif Globals.player.item02 == null:
		Globals.player.item02 = new_item
	else:
		waiting_selection = true
		await item_discarded
		if discarded_item01:
			Globals.player.item01.destroy()
			Globals.player.item01 = new_item
		else:
			Globals.player.item02.destroy()
			Globals.player.item02 = new_item
	
	selected.emit(self)
