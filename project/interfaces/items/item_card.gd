extends Button


@onready var name_label : Label = get_node('Name')
@onready var icon_tex : TextureRect = get_node('Icon')
@onready var description_label : Label = get_node('Description')
@onready var type_label : Label = get_node('Type')
@onready var discard_prompt : Label = get_node('Select_Item_Prompt')
var waiting_selection : bool = false
var discarded_item01 : bool = false

signal selected
signal item_discarded
signal item_set

func _input(event: InputEvent) -> void:
	if waiting_selection:
		if event.is_action_pressed("item_01"):
			discarded_item01 = true
			item_discarded.emit()
		if event.is_action_pressed('item_02'):
			discarded_item01 = false
			item_discarded.emit()

func _on_pressed() -> void:
	var item_scene = load('res://items/' + name_label.text + '.tscn')
	var new_item = item_scene.instantiate()
	new_item.icon_tex = icon_tex.texture
	new_item.parent = Globals.player
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, 'position', position - Vector2(0, 10), 0.2)
	
	selected.emit(self)
	
	if Globals.player.item01 == null:
		Globals.player.item01 = new_item
		new_item.item_num = 0
	elif Globals.player.item02 == null:
		Globals.player.item02 = new_item
		new_item.item_num = 1
	else:
		waiting_selection = true
		discard_prompt.modulate = Color(1, 1, 1, 0)
		discard_prompt.visible = true
		tween.tween_property(discard_prompt, 'modulate', Color(1, 1, 1, 1), 0.2)
		await item_discarded
		if discarded_item01:
			Globals.player.item01.destroy()
			Globals.player.item01 = new_item
			new_item.item_num = 0
		else:
			Globals.player.item02.destroy()
			Globals.player.item02 = new_item
			new_item.item_num = 1
		
	Globals.player.add_child(new_item)
	item_set.emit()
