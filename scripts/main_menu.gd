extends Control

signal startbutton_pressed(origin: String)
signal creditsbutton_pressed(origin: String)
signal quitbutton_pressed(origin: String)

func _on_startbutton_pressed() -> void:
	startbutton_pressed.emit("main_menu")


func _on_creditsbutton_pressed() -> void:
	creditsbutton_pressed.emit("main_menu")


func _on_quitbutton_pressed() -> void:
	quitbutton_pressed.emit("main_menu")
