package main

// ! mostly from: https://github.com/ararslan/termcolor-c/blob/master/include/termcolor-c.h
// I just couldn't be arsed to recopy this thing from some other place...

Ansi :: enum {
    RESET,
    BOLD,
    DARK,
    UNDERLINE,
    BLINK,
    REVERSE,
    CONCEALED,

    BLACK,
    RED, 
    GREEN,
    YELLOW,
    BLUE,
    MAGENTA,
    CYAN,
    WHITE,

    GRAY,

    BG_BLACK,
    BG_GREY,
    BG_RED,
    BG_GREEN,
    BG_YELLOW,
    BG_BLUE,
    BG_MAGENTA,
    BG_CYAN,
    BG_WHITE,
}


apply :: proc(format: Ansi) -> string {
    if !use_colors do return ""
    switch(format){
        case .RESET:      log("\033[00m", sep = "")
        case .BOLD:       log("\033[1m", sep = "")
        case .DARK:       log("\033[2m", sep = "")
        case .UNDERLINE:  log("\033[4m", sep = "")
        case .BLINK:      log("\033[5m", sep = "")
        case .REVERSE:    log("\033[7m", sep = "")
        case .CONCEALED:  log("\033[8m", sep = "")

        case .BLACK:      log("\033[30m", sep = "")
        case .RED:        log("\033[31m", sep = "")
        case .GREEN:      log("\033[32m", sep = "")
        case .YELLOW:     log("\033[33m", sep = "")
        case .BLUE:       log("\033[34m", sep = "")
        case .MAGENTA:    log("\033[35m", sep = "")
        case .CYAN:       log("\033[36m", sep = "")
        case .WHITE:      log("\033[37m", sep = "")

        case .GRAY:       log("\033[0;90m", sep = "")

        case .BG_BLACK:   log("\033[40m", sep = "")
        case .BG_GREY:    log("\033[40m", sep = "")
        case .BG_RED:     log("\033[41m", sep = "")
        case .BG_GREEN:   log("\033[42m", sep = "")
        case .BG_YELLOW:  log("\033[43m", sep = "")
        case .BG_BLUE:    log("\033[44m", sep = "")
        case .BG_MAGENTA: log("\033[45m", sep = "")
        case .BG_CYAN:    log("\033[46m", sep = "")
        case .BG_WHITE:   log("\033[47m", sep = "")
    }
    return "";
}


col :: proc(format: Ansi) -> string {
    if !use_colors do return ""
    switch(format){
        case .RESET:      return "\033[00m"
        case .BOLD:       return "\033[1m"
        case .DARK:       return "\033[2m"
        case .UNDERLINE:  return "\033[4m"
        case .BLINK:      return "\033[5m"
        case .REVERSE:    return "\033[7m"
        case .CONCEALED:  return "\033[8m"

        case .BLACK:       return "\033[30m"
        case .RED:        return "\033[31m"
        case .GREEN:      return "\033[32m"
        case .YELLOW:     return "\033[33m"
        case .BLUE:       return "\033[34m"
        case .MAGENTA:    return "\033[35m"
        case .CYAN:       return "\033[36m"
        case .WHITE:      return "\033[37m"
        
        case .GRAY:       return "\033[0;90m"

        case .BG_BLACK:    return "\033[40m"
        case .BG_GREY:    return "\033[40m"
        case .BG_RED:     return "\033[41m"
        case .BG_GREEN:   return "\033[42m"
        case .BG_YELLOW:  return "\033[43m"
        case .BG_BLUE:    return "\033[44m"
        case .BG_MAGENTA: return "\033[45m"
        case .BG_CYAN:    return "\033[46m"
        case .BG_WHITE:   return "\033[47m"
    }
    return "";
}