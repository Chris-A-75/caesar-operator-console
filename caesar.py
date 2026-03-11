import cmd

class CaesarConsole(cmd.Cmd):
    intro = "Welcome to the Caesar Operator Console. Type help to list commands.\n"
    prompt = 'caesar > '

    available_tools = ["bismarck", "napoleon", "judas"]
    current_tool = None

    def do_help(self, arg):
        print("Available commands:")
        print("help - Show this help message")
        print("tools - List available tools")
        print("select <tool> - Select a tool")
        print("exit - Exit the console")
    def do_exit(self, arg):
        print("Exiting the Caesar Operator Console. Goodbye!")
        return True
    def default(self, arg):
        print("Unknown command: " + arg +". Type 'help' to see available commands.")

    def do_tools(self, arg):
        print("Available tools:")
        for tool in self.available_tools:
            print("- " + tool)
        

    def do_select(self, arg):
        if(arg.strip() == ""):
            print("Usage: select <tool>")
            return False
        if(arg in self.available_tools):
            self.current_tool = arg
            print("Selected tool: " + arg)
            self.prompt = 'caesar (' + arg + ') > '
        else:
            print("Tool not found: " + arg)
            print("Use 'tools' command to see available tools.")

    def do_deselect(self, arg):
        if self.current_tool is None:
            print("No tool is currently selected.")
        else:
            print("Deselected tool: " + self.current_tool)
            self.current_tool = None
            self.prompt = 'caesar > '

if __name__ == '__main__':
    CaesarConsole().cmdloop()