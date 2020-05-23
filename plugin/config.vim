let g:pastebin_services = {
  \   "mozilla": {
  \     "url": "https://paste.mozilla.org/api/", "syntax": "lexer",
  \     "filetype": {
  \       "text": "_text",
  \     },
  \   },
  \   "dpaste.org": {
  \     "url": "https://dpaste.org/api/", "syntax": "lexer",
  \     "filetype": {
  \       "cpp": "c",
  \       "text": "_text",
  \     }
  \   }
  \ }

let g:enabled_pastebin_service = "mozilla"
