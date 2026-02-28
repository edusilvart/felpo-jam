extends PanelContainer


@onready var kills : Label = get_node('%kills')
@onready var hits : Label = get_node('%hits')
@onready var boss : Label = get_node('%boss')
@onready var title : Label = get_node('%Title')
@onready var back_button : Button = get_node('%Back_Button')
var kills_number : int = 0
var hits_number : int = 0
var boss_number : float = 0

var main_menu : String = "res://scenes/main_menu.tscn"

signal done

func _ready() -> void:
	visible = false

func enter(win : bool) -> void:
	if win:
		title.text = 'VITÓRIA!'
	else:
		title.text = 'DERROTA'
	
	back_button.grab_focus()
	
	modulate = Color(1, 1, 1, 0)
	visible = true
	kills_number = 0
	hits_number = 0
	boss_number = 0
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, 'modulate', Color(1, 1, 1, 1), 0.2)
	
	kills.text = '0'
	var kills_target = Globals.total_kills
	tween.tween_property(self, 'kills_number', kills_target, 1.3)
	
	hits.text = '0'
	var hits_target = Globals.hits_taken
	tween.tween_property(self, 'hits_number', hits_target, 1.3)
	
	boss.text = '0'
	var boss_target = Globals.boss_duration
	tween.tween_property(self, 'boss_number', boss_target, 1.3)

func _process(_delta: float) -> void:
	kills.text = str(kills_number)
	hits.text = str(hits_number)
	
	var total_time : int = int(boss_number)
	var minutes : int = total_time / 60
	var seconds : int = total_time % 60
	var boss_time = '%02d:%02d' % [minutes, seconds]
	boss.text = boss_time

func exit() -> void:
	Globals.total_kills = Globals.kills
	Globals.kills = 0
	done.emit()
	visible = false

func _on_back_button_pressed() -> void:
	SFX_MANAGER.cancel()
	ScenesManager.change_scene(main_menu, get_parent())
