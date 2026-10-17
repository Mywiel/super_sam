extends Label

func _ready():
	var version = ProjectSettings.get_setting("application/config/version")
	text = "v" + str(version)
