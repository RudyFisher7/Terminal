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


var cmd_lib : = CommandLibrary
var cmd : String = ""
var parsed_cmd : PoolStringArray = []
var cmd_delimiter : String = " "
var cmd_execute : String = "\n"

onready var terminal : TextEdit = get_node(path_to_terminal)


func _ready() -> void:
	_connect_cmd_signal_to_world_manager()
	_add_cmds_to_keywords()
	terminal.text += prompt


func _connect_cmd_signal_to_world_manager() -> void:
	var sig : String = "cmd_executed"
	var method : String = "_on_Terminal_cmd_executed"
	var err = connect(sig, WorldManager, method)


func _add_cmds_to_keywords() -> void:
	for cmd in cmd_lib.get_cmds():
		terminal.add_keyword_color(cmd, Color.royalblue);


func _parse_cmd_and_args() -> void:
	parsed_cmd = cmd.split(cmd_delimiter, false)
	
	for string in parsed_cmd:
		print(string)


func _execute_cmd() -> void:
	_parse_cmd_and_args()
	var err_msg : int = cmd_lib.validate(parsed_cmd)
	if err_msg == cmd_lib.CmdErrors.CMD_VALID:
		print(parsed_cmd[0] + " is a cmd!")
		match parsed_cmd[0]:
			"hi":
				terminal.text += "Hello! ^_^ I'm so happy!\n"
			"quit":
				terminal.text += "Bye! ^_^ Bye!\n"
				_set_cursor_to_next_prompt()
				terminal.readonly = true
				if parsed_cmd.size() == 2:
					var duration : float = float(parsed_cmd[1])
					var timer : = get_tree().create_timer(duration)
					yield(timer, "timeout")
				get_tree().quit(0)
			_:
				emit_signal("cmd_executed", parsed_cmd)
	else:
		terminal.text += cmd_lib.CmdErrors.keys()[err_msg] + "\n"
	
	terminal.text += prompt
	cmd = ""
	parsed_cmd = []
	_set_cursor_to_next_prompt()


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
