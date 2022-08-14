extends CanvasLayer

# TODO: Parameterize functions (e.g. "mv holly x y", could be a move 
# command that would move the character named "Holly" to position 
# x,y)
#####################################################################
# Represents a command line terminal to allow player to type and
# execute commands to manipulate properties of the game world.
#####################################################################

# @param PoolStringArray function_to_obey
signal function_executed(function_to_obey)

export var path_to_terminal : NodePath

const prompt : String = ">>"
const newline : String = "\n"


var _current_program : Program


var function_lib : Node = GlobalCommandLibrary
var function : String = ""
var parsed_function : PoolStringArray = []
var function_delimiter : String = " "
var function_execute : String = "\n"
var cursor_prev_line : int = 0


onready var terminal : TextEdit = get_node(path_to_terminal)


func _ready() -> void:
	var err = terminal.get_menu().connect("visibility_changed", self,\
											 "_force_popup_to_hide")
	_connect_function_signal_to_world_manager()
	_add_functions_to_keywords()
	terminal.text += prompt
	terminal.cursor_set_block_mode(true)
	terminal.cursor_set_blink_enabled(false)
	terminal.grab_focus()


# Connects the signals this terminal Node emits to the necessary
# Nodes that need to receive them.
func _connect_function_signal_to_world_manager() -> void:
	var sig : String = "function_executed"
	var method : String = "_on_Terminal_function_executed"
	var err = connect(sig, WorldManager, method)


# Adds all the names of the functions and subfunctions into
# this terminal's TextEdit Node's keywords for syntax
# highlighting.
func _add_functions_to_keywords() -> void:
	for function in function_lib.get_function_names():
		terminal.add_keyword_color(function, Color.royalblue)


# Parses the function that was just imputed by the user.
# Essentially, splits the entered String into a
# PoolStringArray.
func _parse_function_and_args() -> void:
	parsed_function = function.split(function_delimiter, false)
	print(parsed_function)


# Executes the entered function if valid, printing a error message
# or success message to the terminal. If this terminal doesn't
# execute the function directly, it emits the necessary signal that
# correlates with the function.name, so the receiver can carry on the
# execution.
func _execute_function() -> void:
	_parse_function_and_args()
	var err_msg : int = function_lib.validate(parsed_function)
	terminal.text += Function.Error.keys()[err_msg] + newline
	if err_msg == Function.Error.function_VALID:
		match parsed_function[0]:
			"help":
				_execute_help(parsed_function)
			"hi":
				terminal.text += "Hello! ^_^ I'm so happy!\n"
			"quit":
				_execute_quit(parsed_function)
			_:
				emit_signal("function_executed", parsed_function)
	
	terminal.text += prompt
	function = ""
	parsed_function = []
	_set_cursor_to_next_prompt()


func _execute_help(parsed_function : PoolStringArray) -> void:
	terminal.text += "Currently connected functions:\n"
	var temp_text : String = ""
	for function_name in function_lib.get_function_names():
		terminal.text += function_lib.get_function_to_string(function_name) + newline
	#temp_text = temp_text.trim_suffix(newline)
	terminal.text += temp_text


func _execute_quit(parsed_function : PoolStringArray) -> void:
	terminal.text += "Bye! ^_^ Bye!\n"
	_set_cursor_to_next_prompt()
	terminal.readonly = true
	if parsed_function.size() == 2:
		var duration : float = float(parsed_function[1])
		var timer : = get_tree().create_timer(duration)
		yield(timer, "timeout")
	get_tree().quit(0)


func _set_cursor_to_next_prompt() -> void:
	var line_count : int = terminal.get_line_count()
	terminal.cursor_set_line(line_count - 1)
	terminal.cursor_set_column(prompt.length())


func _on_TextEdit_text_changed() -> void:
	var cursor_column : int = terminal.cursor_get_column()
	var cursor_line : int = terminal.cursor_get_line()
	var line_count : int = terminal.get_line_count()
	var line : String = terminal.get_line(line_count - 1)
	var revised_line : String = line
	
	if cursor_prev_line != cursor_line:
		if !terminal.text.ends_with(function_execute):
			terminal.undo()
			line = terminal.get_line(line_count - 2) # -2 because we are still in signal callback handler function
			terminal.cursor_set_column(line.length())
		else:
			_execute_function()
			cursor_prev_line = terminal.cursor_get_line()
	else:
		if !terminal.text.ends_with(function_execute): # Is this check redundant?
			if !line.begins_with(prompt):
				var arrow : String = ">" 
				if!line.begins_with(arrow):
					revised_line = line.indent(prompt)
					cursor_column += prompt.length()
				else:
					revised_line = line.indent(arrow)
					cursor_column += arrow.length()
				terminal.set_line(line_count - 1, revised_line)
				terminal.cursor_set_line(line_count - 1)
				terminal.cursor_set_column(cursor_column)
			function = revised_line.trim_prefix(prompt)
	terminal.clear_undo_history()


func _on_TextEdit_cursor_changed() -> void:
	var cursor_line : int = terminal.cursor_get_line()
	var line_count : int = terminal.get_line_count()
	var cursor_column : int = terminal.cursor_get_column()
	
	if cursor_line < line_count - 1:
		terminal.cursor_set_line(line_count - 1)
	
	if cursor_column < prompt.length():
		terminal.cursor_set_column(prompt.length())


func _force_popup_to_hide() -> void:
	terminal.get_menu().visible = false
