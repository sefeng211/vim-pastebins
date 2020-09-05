execute "command! PastebinPaste :call core#post_text_visual()"
execute "command! PastebinPasteAll :call core#post_entire_buffer()"
execute "command! PastebinPasteList :call core#load_saved_pastes()"
