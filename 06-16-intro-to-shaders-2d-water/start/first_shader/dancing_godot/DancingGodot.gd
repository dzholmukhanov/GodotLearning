extends TextureRect

onready var amplitude = material.get_shader_param("amplitude")

func _ready():
#	print(amplitude)
#	assert amplitude != null
	pass

func _on_AmplitudeController_amplitude_changed(amplitude_x):
	amplitude.x = amplitude_x
	material.set_shader_param("amplitude", amplitude)
