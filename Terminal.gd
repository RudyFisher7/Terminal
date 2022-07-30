extends Control

# TODO: Parameterize cmds (e.g. "mv holly x y", could be a move 
# command that would move the character named "Holly" to position 
# x,y)
#####################################################################
# Represents a command line terminal to allow player to type and
# execute commands to manipulate properties of the game world.
#####################################################################

# @param PoolStringArray cmd_to_obey
signal cmd_executed(cmd_to_obey)

export var path_to_terminal : NodePath

const prompt : String = ">>"
const newline : String = "\n"


var cmd_lib : Node = CommandLibrary
var cmd : String = ""
var parsed_cmd : PoolStringArray = []
var cmd_delimiter : String = " "
var cmd_execute : String = "\n"


onready var terminal : TextEdit = get_node(path_to_terminal)


func _ready() -> void:
	var err = terminal.get_menu().connect("visibility_changed", self, "_force_popup_to_hide")
	_connect_cmd_signal_to_world_manager()
	_add_cmds_to_keywords()
	terminal.text += prompt
	terminal.cursor_set_block_mode(true)
	terminal.cursor_set_blink_enabled(false)


# Connects the signals this terminal Node emits to the necessary
# Nodes that need to receive them.
func _connect_cmd_signal_to_world_manager() -> void:
	var sig : String = "cmd_executed"
	var method : String = "_on_Terminal_cmd_executed"
	var err = connect(sig, WorldManager, method)


# Adds all the names of the cmds and subcmds into
# this terminal's TextEdit Node's keywords for syntax
# highlighting.
func _add_cmds_to_keywords() -> void:
	for cmd in cmd_lib.get_cmd_names():
		terminal.add_keyword_color(cmd, Color.royalblue)
	for cmd in cmd_lib.get_all_subcmds():
		terminal.add_keyword_color(cmd, Color.tan)


# Parses the cmd that was just imputed by the user.
# Essentially, splits the entered String into a
# PoolStringArray.
func _parse_cmd_and_args() -> void:
	parsed_cmd = cmd.split(cmd_delimiter, false)
	print(parsed_cmd)


# Executes the entered cmd if valid, printing a error message
# or success message to the terminal. If this terminal doesn't
# execute the cmd directly, it emits the necessary signal that
# correlates with the cmd.name, so the receiver can carry on the
# execution.
func _execute_cmd() -> void:
	_parse_cmd_and_args()
	var err_msg : int = cmd_lib.validate(parsed_cmd)
	terminal.text += Cmd.Error.keys()[err_msg] + newline
	if err_msg == Cmd.Error.CMD_VALID:
		match parsed_cmd[0]:
			"help":
				_execute_help(parsed_cmd)
			"hi":
				terminal.text += "Hello! ^_^ I'm so happy!\n"
			"quit":
				_execute_quit(parsed_cmd)
			_:
				emit_signal("cmd_executed", parsed_cmd)
	
	terminal.text += prompt
	cmd = ""
	parsed_cmd = []
	_set_cursor_to_next_prompt()


func _execute_help(parsed_cmd : PoolStringArray) -> void:
	terminal.text += "Currently connected cmds:\n"
	var temp_text : String = ""
	for cmd_name in cmd_lib.get_cmd_names():
		terminal.text += cmd_lib.get_cmd_to_string(cmd_name) + newline
	#temp_text = temp_text.trim_suffix(newline)
	terminal.text += temp_text


func _execute_quit(parsed_cmd : PoolStringArray) -> void:
	terminal.text += "Bye! ^_^ Bye!\n"
	_set_cursor_to_next_prompt()
	terminal.readonly = true
	if parsed_cmd.size() == 2:
		var duration : float = float(parsed_cmd[1])
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
	#TODO: Adjust for pressing enter while cursor is not at end of cmd
	if !terminal.text.ends_with(cmd_execute):
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
		cmd = revised_line.trim_prefix(prompt)
	else:
		_execute_cmd()


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
