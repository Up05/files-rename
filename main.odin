package main
// file rename

import "core:fmt"
import "core:os"
import "core:path/filepath"
import regex "core:text/match"
import "core:strings"
import "core:runtime"
import "core:text/scanner"
import "core:bufio"
import "core:unicode/utf8"

error_count := 0

log   :: fmt.print
logf  :: fmt.printf
logln :: fmt.println

errf  :: proc(format: string, args: ..any) -> int { 
    error_count += 1
    return fmt.fprintf(os.stderr, format, ..args) 
}


main :: proc(){
    using os
    using filepath
    
    args_parse()

    // file list
    // ########################################################################

    dir_path, ok := filepath.abs(path)
    logln(dir_path, ok)
    // dir_path = join({ get_current_directory(), path })
    dirf, errno0 := open(dir_path)
    if errno0 != 0 { errf("Failed to open main path with error code: %d", errno0); return }
    file_list, errno1 := read_dir(dirf, 0)
    if errno1 != 0 { errf("Failed to list dir files with error code: %d", errno1); return }

    max_file_name_len := 0
    for file in file_list {
        if len(file.name) > max_file_name_len do max_file_name_len = len(file.name)
    }

    // prints/processes change table
    // ########################################################################

    file_name_map := make_map(map [string] string)

    apply(.GRAY)
    logf("%-*s | %s\n", max_file_name_len, "from", "to")
    logln("---------------------------------------------------")
    for file in file_list {
        select_matcher := regex.matcher_init(file.name, selector)
        test, selected := regex.matcher_match(&select_matcher)
        if !selected {
            logln(col(.GRAY), file.name, sep = "")
            continue;
        }
        
        out := regex.gsub_allocator(file.name, find, replace)

        if file.name != out {
            file_name_map[file.name] = out
            logf("%s%-*s%s | %s%s\n", col(.CYAN), max_file_name_len, file.name, col(.GRAY), col(.YELLOW), out)
        }
        else do logf("%s%-*s | %s\n", col(.GRAY), max_file_name_len, file.name, out)
    }
    apply(.GRAY)
    logln("---------------------------------------------------")

    // confirmation
    // ########################################################################

    if !confirm {
        stream := os.stream_from_handle(os.stdin)
        s: bufio.Scanner
        bufio.scanner_init(&s, stream)
        defer bufio.scanner_destroy(&s)

        log("rename files (otherwise program will exit) (y/n): ")
        bufio.scanner_scan(&s)
        answer_str := strings.to_lower(bufio.scanner_text(&s))
        
        if utf8.rune_at_pos(answer_str, 0) != 'y' do return // KIND OF utf-8 support, I could just str[0]
    }

    // renaming
    // ########################################################################


    for k, v in file_name_map {
        a, _ := strings.concatenate({ dir_path, "\\", k }) // maybe, should be: filepath.SEPARATOR_STRING
        b, _ := strings.concatenate({ dir_path, "\\", v })

        os.rename(a, b)

    }


    apply(.RESET)
}



/*
    [path] selector find replace
    -y                              # yes
    --no-color[s]                   # no ansi color codes


*/