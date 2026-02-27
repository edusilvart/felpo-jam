extends Control


var scene_path : String

var progress = []

signal finished_loading(packed_scene)

func load_scene(new_scene):
	scene_path = new_scene
	ResourceLoader.load_threaded_request(scene_path)

func _process(_delta):
	if scene_path:
		var status = ResourceLoader.load_threaded_get_status(scene_path, progress)
		
		if status == ResourceLoader.THREAD_LOAD_LOADED:
			var packed_scene = ResourceLoader.load_threaded_get(scene_path)
			finished_loading.emit(packed_scene)
