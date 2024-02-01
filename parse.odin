package main

import "core:os"

ArgsErrorType :: enum { BAD_PATH, BAD_SELECTOR, BAD_FIND, BAD_REPLACE }
ARGS_ERRS := map[ArgsErrorType] string {
    .BAD_PATH       = "Expected path \"%s\" to be a value, but found it to be %s instead...\n",
    .BAD_SELECTOR   = "Expected selector \"%s\" to be a value, but found it to be %s instead...\n",
    .BAD_FIND       = "Expected find \"%s\" to be a value, but found it to be %s instead...\n",
    .BAD_REPLACE    = "Expected replace \"%s\" to be a value, but found it to be %s instead...\n"
}


ArgType :: enum { VALUE, FLAG, NONE }

get_arg :: proc(index: int) -> (string, ArgType) {
    if is_eol(index)             do return "", .NONE
    if is_flag(&os.args[index])  do return os.args[index], .FLAG
    
    return os.args[index], .VALUE
}

is_flag :: proc(arg: ^string) -> bool { return arg^[0] == '-' }
is_eol  :: proc(index: int)   -> bool { return index < 0 || index > len(os.args) - 2 } 

help_requested, path_specified : bool

args_parse :: proc(){

    // handling help flag
    // ########################################################################

    help_requested = is_eol(1)
    handle_help_cmd()
    switch os.args[1] { case "-h", "--help", "-?": help_requested = true }
    handle_help_cmd()

    // handling the 3 main parameters & optional first param -- path
    // ########################################################################

    path_specified = !is_eol(4) && !is_flag(&os.args[4]) // [path] selector find replace

    o :: proc(index: int) -> int { return index - int(!path_specified) }

    {
        type : ArgType
        if path_specified {
            path, type = get_arg(  1 );    if type != .VALUE do errf(ARGS_ERRS[.BAD_PATH], path, type)
        }
        selector, type = get_arg(o(2));    if type != .VALUE do errf(ARGS_ERRS[.BAD_SELECTOR], selector, type)
        find,     type = get_arg(o(3));    if type != .VALUE do errf(ARGS_ERRS[.BAD_FIND], find, type)
        replace,  type = get_arg(o(4));    if type != .VALUE do errf(ARGS_ERRS[.BAD_REPLACE], replace, type)
    }

    if error_count > 0 do os.exit(1)

    // handling extra config flags
    // ########################################################################

    for i := o(5); i < len(os.args); i += 1 {
        switch os.args[i] {
            case "-y", "--yes": confirm = true
            case "--no-colors": use_colors = false
        }

    }

}


handle_help_cmd :: proc(){
    if help_requested {
        logln (
`fr.exe (files-rename) requires at least 3 arguments!
fr.exe [path] selector find replace [-h] [--no-colors]

path - path to folder, where the files are located
selector - regex for selecting specific files (<find> also partially does this)
find - regex for text to replace it is, by default global(/.../g)
replace - regex to replace the text with
-y - y[es], automatically confirms replacement
--no-colors - disables ansi codes`
        )
        os.exit(0)
    }
}