" Credit of this function: https://stackoverflow.com/a/6271254
function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function s:get_config()
    let selected = g:enabled_pastebin_service
    if has_key(g:pastebin_services, selected)==1
        let options = g:pastebin_services[selected]
        return options
    else
        echo "No such service"
        return {}
    endif
endfunction

" There are filetypes that are not supported by certain pastebin services,
" in such cases, we need to change the filetype to a different one
function s:get_file_type(config)
    let file_type = &filetype
    if has_key(a:config, "filetype")
        let provided_filetype = a:config["filetype"]
        echo provided_filetype
        if has_key(provided_filetype, file_type)==1
            return provided_filetype[file_type]
        endif
    endif
    return file_type
endfunction

" Format the selection by adding escape character to the selection
function s:format_selection(selection)
    return substitute(a:selection, '"', '\\"', "g")
endfunction

function Post_text_visual()
    let selected = s:get_visual_selection()
    " Invalid selection
    if strlen(selected)==0
        echo "Error: No text selected"
        return
    endif

    let formated = s:format_selection(selected)

    let config = s:get_config()

    let file_type = s:get_file_type(config)
    " Invalid service name
    if config=={}
        return
    endif

    let content = "content=" . formated
    let syntax_string = config["syntax"] . "=" . file_type

    let command = 'curl -s -F ' . '"' . content . '" '
        \ . "-F " . syntax_string . " "
        \ . config["url"]
    let result = system(command)

    echo result
endfunction
