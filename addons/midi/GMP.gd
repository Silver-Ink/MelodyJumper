@tool
"""
	Godot MIDI Player Plugin by arlez80 (Yui Kinomoto)
"""

extends EditorPlugin

#var sf2_import_plugin

func _enter_tree( ):
	pass

	#self.sf2_import_plugin = preload("import/SF2Import.gd").new( )
	#self.add_import_plugin( self.sf2_import_plugin )

func _exit_tree( ):
	self.remove_custom_type( "GodotMIDIPlayer" )
	#self.remove_import_plugin( self.sf2_import_plugin )
	#self.sf2_import_plugin = null

func _has_main_screen():
	return true

func _make_visible( visible:bool ):
	pass

func _get_plugin_name( ):
	return "Godot MIDI Player"
