extends PanelContainer


@onready var master_button : Button = get_node('%Master')
@onready var music_button : Button = get_node('%Music')
@onready var sfx_button : Button = get_node('%SFX')
@onready var fullscreen_button : Button = get_node('%Fullscreen')

signal exit

func _ready() -> void:
	visible = false

func enter() -> void:
	visible = true
	update_buttons()
	master_button.grab_focus()

func leave() -> void:
	exit.emit()
	visible = false

func update_buttons() -> void:
	master_button.text = str(int(Globals.master_vol)) + '%'
	music_button.text = str(int(Globals.music_vol)) + '%'
	sfx_button.text = str(int(Globals.sfx_vol)) + '%'
	if Globals.fullscreen:
		fullscreen_button.text = 'SIM'
	else:
		fullscreen_button.text = 'NÃO'


func _on_master_pressed() -> void:
	var volume : float = 0
	if Globals.master_vol == 100:
		Globals.master_vol = 0
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_mute(0, false)
		Globals.master_vol += 25
		volume = linear_to_db(Globals.master_vol / 100)
	
	AudioServer.set_bus_volume_db(0, volume)
	
	master_button.text = str(int(Globals.master_vol)) + '%'

func _on_music_pressed() -> void:
	var volume : float = 0
	if Globals.music_vol == 100:
		Globals.music_vol = 0
		AudioServer.set_bus_mute(1, true)
	else:
		AudioServer.set_bus_mute(1, false)
		Globals.music_vol += 25
		volume = linear_to_db(Globals.music_vol / 100)
	
	AudioServer.set_bus_volume_db(1, volume)
	
	music_button.text = str(int(Globals.music_vol)) + '%'

func _on_sfx_pressed() -> void:
	var volume : float = 0
	if Globals.sfx_vol == 100:
		Globals.sfx_vol = 0
		AudioServer.set_bus_mute(2, true)
	else:
		AudioServer.set_bus_mute(2, false)
		Globals.sfx_vol += 25
		volume = linear_to_db(Globals.sfx_vol / 100)
	
	AudioServer.set_bus_volume_db(2, volume)
	
	sfx_button.text = str(int(Globals.sfx_vol)) + '%'

func _on_back_pressed() -> void:
	leave()

func _on_fullscreen_pressed() -> void:
	if Globals.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Globals.fullscreen = false
		fullscreen_button.text = 'NÃO'
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Globals.fullscreen = true
		fullscreen_button.text = 'SIM'
