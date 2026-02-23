extends Control



@onready var card_scene : PackedScene = preload("res://interfaces/items/item_card.tscn")
@onready var title_label : Label = get_node('Title_Label')
@onready var cards_container : HBoxContainer = get_node('%Cards_Container')

@onready var title_pos = title_label.position

# ITEM NAME, ITEM DESCRIPTION
var items = [
	['Café', 'Aumente a velocidade de movimento e ataque em 30% por 3s. Consumível'],
	['Cachorro', 'Companheiro canino, morde uma lição aleatória a cada 2s. Ataque'],
	['Maçã', 'Aumente a velocidade de movimento e ataque em 30% por 3 segundos. Consumível'],
	['Carimbada', 'Acerte o chão empurrando inimigos para longe. Ataque'],
	['Clipe de Papel', 'Lance um clipe que agrupa inimigos próximos. Ataque'],
	['Rodopio', 'Rodopie girando o carimbo e acertando quem estiver no caminho. Ataque'],
	['Grampeador', 'Atira grampos em volta a cada 3s. Ataque']
]
var cards = []

#signal card_selected
signal ended

func _ready() -> void:
	visible = false

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action('ui_left'):
		#cards_container.get_child(0).grab_focus()
	#if event.is_action('ui_right'):
		#cards_container.get_child(2).grab_focus()
	#if event.is_action('ui_accept'):
		#cards_container.get_child(1).grab_focus()
	#if event.is_action('ui_down') or event.is_action('ui_cancel'):
		#resume_button.grab_focus()

func enter() -> void:
	visible = true
	items.shuffle()
	for n in 3:
		build_card(n)
	
	
	title_pos = title_label.position
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	title_label.position.y -= 250
	tween.tween_property(title_label, "position", title_pos, 0.2)
	
	cards_container.modulate = Color(1, 1, 1, 0)
	tween.tween_property(cards_container, "modulate", Color(1, 1, 1, 1), 0.5)


func build_card(card_number : int) -> void:
	var card_id = items[card_number]
	var new_card = card_scene.instantiate()
	cards_container.add_child(new_card)
	new_card.name_label.text = card_id[0]
	var card_texture = load("res://interfaces/items/Icons/" + card_id[0] + ".png")
	new_card.icon_tex.texture = card_texture
	new_card.description_label.text = card_id[1]
	
	new_card.selected.connect(item_selected)
	
	cards.append(new_card)

func find_item_selected(item_name) -> int:
	for i in items.size():
		if items[i][0] == item_name:
			return i
	return -1

func item_selected(item) -> void:
	# remove the card selected from selection list
	items.remove_at(find_item_selected(item.name_label.text))
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	for card in cards_container.get_children():
		if card != item:
			card.disabled = true
			tween.tween_property(card, 'modulate', Color(1, 1, 1, 0), 0.15)
	
	await get_tree().create_timer(1).timeout
	
	exit()

func exit() -> void:
	visible = false
	for child in cards_container.get_children():
		child.queue_free()
	ended.emit()
