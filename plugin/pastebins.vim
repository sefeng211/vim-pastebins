py3 << EOF
import vim
from urllib import request, parse

STORED_PASTES = "data/_links.txt"
# There are filetypes that are not supported by certain pastebin services,
# in such cases, we'd need to convert the filetype to a different one
def get_file_type(config):
    file_type = vim.eval("&filetype")

    if "filetype" in config:
        if file_type in config["filetype"]:
           return config["file_type"][file_type]
    return file_type

def read_pastes():
    with open(STORED_PASTES, 'r') as f:
        print(f.readlines())

def save_pastes(link):
    with open(STORED_PASTES, 'a') as f:
        f.write(link)
        f.write("\n");

def post_text():
    service = vim.eval("g:enabled_pastebin_service")
    content = vim.eval("s:get_visual_selection()")
    config = vim.eval("g:pastebin_services")

    try:
        config = config[service]
    except KeyError:
        print("Invalid service name is provided")
        return

    if not content:
        print("Invalid selection")
        return

    url = config["url"]
    syntax_field = config["syntax"]
    data = {
        "content": content,
        syntax_field: get_file_type(config)
    }

    data = parse.urlencode(data).encode()
    req =  request.Request(url, data=data)
    try:
        resp = request.urlopen(req)
        link = resp.read().decode("utf-8")
        save_pastes(link)
        print(link)
    except Exception as e:
        print("Failed to post the selection")
        print(e)
EOF

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

function s:post_text_visual()
    if !has("python3")
        echo "vim has to be compiled with +python3 to run PastebinPaste"
        finish
    endif
    py3 post_text()
endfunction

execute "command! PastebinPaste :call s:post_text_visual()"
