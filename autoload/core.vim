py3 << EOF
import vim
import json
import collections
from datetime import datetime
from urllib import request, parse

STORED_PASTES = "data/_links.txt"

submitted_pastes = []
# There are filetypes that are not supported by certain pastebin services,
# in such cases, we'd need to convert the filetype to a different one
def get_file_type(config, file_type):
    if "filetype" in config:
        if file_type in config["filetype"]:
            return config["filetype"][file_type]
    return file_type

# Helper function converts the stored pastes into a human readable format
def read_pastes():
    data = collections.OrderedDict({})
    path = vim.eval("s:path") + "/" + "../"
    with open(path + STORED_PASTES, 'r') as f:
        for line in f.readlines():
            line = json.loads(line)
            try:
                link = line["link"]
                filetype = line["filetype"]
                time = line["time"]
                if filetype not in data:
                    data[filetype] = []
                data[filetype].append(line)
            except:
                continue
    submitted_pastes.clear()
    for filetype in data:
        try:
            submitted_pastes.append(filetype)
            for line in data[filetype]:
                paste = "  " + line["link"] + ", " + line["time"]
                submitted_pastes.append(paste)
        except:
            continue

def save_pastes(link, file_type):
    path = vim.eval("s:path") + "/" + "../"
    data = {
        "link": link,
        "filetype": file_type,
        "time": datetime.now().strftime("%m/%d/%Y, %H:%M:%S")
    }
    with open(path + STORED_PASTES, 'a') as f:
        f.write(json.dumps(data))
        f.write("\n");

def post_visual_text():
    content = vim.eval("s:get_visual_selection()")
    post_text(content)

def post_data(url, data):
    encoded_data = parse.urlencode(data).encode()
    req =  request.Request(url, data=encoded_data)
    resp = request.urlopen(req)
    return resp.read().decode("utf-8")

def post_entire_buffer():
    content = vim.eval("s:get_entire_buffer()")
    post_text(content)

def post_text(content):
    service = vim.eval("g:enabled_pastebin_service")
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
    type = vim.eval("&filetype")
    file_type = get_file_type(config, type)
    original_data = {
        "content": content,
        syntax_field: file_type
    }

    try:
        link = post_data(url, original_data)
        save_pastes(link, file_type)
        print(link)
    except Exception as e:
        # This is most likely that the syntax of the file
        # is not supported, fallback to raw text
        file_type = get_file_type(config, "text")
        original_data[syntax_field] = file_type
        try:
            link = post_data(url, original_data)
            print("Using raw text as the file type")
            save_pastes(link, file_type)
            print(link)
        except Exception as e:
            print("Failed to submit the paste")
EOF

let s:path = expand('<sfile>:p:h')

" Credit of this function: https://stackoverflow.com/a/6271254
function s:get_visual_selection()
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

function! s:get_entire_buffer()
    let buffer = join(getline(1, '$'), "\n")
    return buffer
endfunction

function core#post_text_visual()
    if !has("python3")
        echo "vim has to be compiled with +python3 to run PastebinPaste"
        finish
    endif
    py3 post_visual_text()
endfunction

function core#load_saved_pastes()
    py3 read_pastes()
    let submitted_pastes = py3eval('submitted_pastes')

    let counter = 0
    new
    for line in submitted_pastes
        let counter += 1
        call setline(counter, line)
    endfor
    set ro bt=nofile

endfunction

function core#post_entire_buffer()
    py3 post_entire_buffer()
endfunction
