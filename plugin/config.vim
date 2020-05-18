let g:pastebin_services = {
  \   "mozilla": {
  \     "url": "https://paste.mozilla.org/api/", "syntax": "lexer",
  \   },
  \   "dpaste.org": {
  \     "url": "https://dpaste.org/api/", "syntax": "lexer",
  \     "filetype": {
  \       "cpp": "c",
  \     }
  \   }
  \ }

let g:enabled_pastebin_service = "mozilla"
