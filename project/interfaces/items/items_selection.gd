extends Control


@onready var fade : ColorRect = get_node('Fade')
@onready var card_scene : PackedScene = preload("res://interfaces/items/item_card.tscn")
@onready var title_label : PanelContainer = get_node('%Title')
@onready var cards_container : HBoxContainer = get_node('%Cards_Container')
@onready var back_button : Button = get_node('%Back_Button')
@onready var points : PanelContainer = get_node('%Points')

# ITEM ID, ITEM NAME, ITEM DESCRIPTION
var items = [
	['Coffee', 'Café', 'Aumente a velocidade de movimento e ataque em 40% por 8s.', 'Consumível'],
	['Dog', 'Cachorro', 'Morde uma lição aleatória.', 'Habilidade'],
	['Apple', 'Maçã', 'Cure +3 de vida.', 'Consumível'],
	['Stomp', 'Carimbada', 'Acerte o chão empurrando inimigos para longe.', 'Habilidade'],
	['Clip', 'Clipe de Papel', 'Lance um clipe que agrupa inimigos próximos.', 'Habilidade'],
	['Spin', 'Rodopio', 'Rodopie girando o carimbo e acertando quem estiver no caminho.', 'Habilidade'],
	['Stapler', 'Grampeador', 'Atira 8 grampos em volta.', 'Habilidade']
]
var cards = []

#signal card_selected
signal ended

func _ready() -> void:
	visible = false

func enter() -> void:
	visible = true
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	fade.color = Color(0, 0, 0, 0)
	tween.tween_property(fade, "color", Color(0, 0, 0, 0.4), 0.3)
	
	title_label.modulate = Color(1, 1, 1, 0)
	cards_container.modulate = Color(1, 1, 1, 0)
	back_button.modulate = Color(1, 1, 1, 0)
	
	points.enter()
	await points.done
	start_shop()

func start_shop() -> void:
	items.shuffle()
	for n in 3:
		build_card(n)
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	tween.tween_property(title_label, "modulate", Color(1, 1, 1, 1), 0.3)
	
	tween.tween_property(cards_container, "modulate", Color(1, 1, 1, 1), 0.5)
	
	tween.tween_property(back_button, 'modulate', Color(1, 1, 1, 1), 0.3)
	
	cards_container.get_child(1).grab_focus()

func build_card(card_number : int) -> void:
	var card_id = items[card_number]
	var new_card = card_scene.instantiate()
	cards_container.add_child(new_card)
	new_card.name = card_id[0]
	new_card.name_label.text = card_id[1]
	var card_texture = load("res://interfaces/items/Icons/" + card_id[0] + ".png")
	new_card.icon_tex.texture = card_texture
	new_card.description_label.text = card_id[2]
	new_card.type_label.text = card_id[3]
	
	new_card.selected.connect(item_selected)
	new_card.item_set.connect(item_set)
	
	cards.append(new_card)

func find_item_selected(item_name) -> int:
	for i in items.size():
		if items[i][0] == item_name:
			return i
	return -1

func item_selected(item) -> void:
	# remove the card selected from selection list
	items.remove_at(find_item_selected(item.name))
	
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	
	for card in cards_container.get_children():
		card.disabled = true
		if card != item:
			tween.tween_property(card, 'modulate', Color(1, 1, 1, 0), 0.15)

func item_set() -> void:
	var tween := get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(fade, "color", Color(0, 0, 0, 0), 0.3)
	
	await get_tree().create_timer(1).timeout
	exit()

func exit() -> void:
	visible = false
	for child in cards_container.get_children():
		child.queue_free()
	ended.emit()

func _on_back_button_pressed() -> void:
	SFX_MANAGER.cancel()
	exit()
