extends Control


@onready var items_container : HBoxContainer = get_node('%ItemsIcon')
@onready var HP_bar : TextureProgressBar = get_node('%HP_Bar')
@onready var aula_label : Label = get_node('%Aula_Label')
@onready var timer_label : Label = get_node('%Timer_Label')
@onready var intro : VideoStreamPlayer = get_node('%Intro_Video')
@onready var skip_button = get_node('%Skip_Intro')

var on_boss : bool = false
var boss_runtime : float = 0

func _ready() -> void:
	Globals.HUD = self

func _unhandled_input(event: InputEvent) -> void:
	if intro.is_playing():
		if event.is_action_pressed('ui_accept'):
			intro.stop()
			intro.finished.emit()

func play_intro() -> bool:
	skip_button.visible = true
	intro.play()
	await intro.finished
	skip_button.visible = false
	return true

func boss_start() -> void:
	on_boss = true
	aula_label.text = ''

func _process(delta: float) -> void:
	if on_boss:
		boss_runtime += delta
		timer_label.text = str(int(boss_runtime))

func update_hp(new_HP) -> void:
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(HP_bar, 'value', new_HP, 0.5)
