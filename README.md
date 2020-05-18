Vim PasteBins
=============
A vim plugin that helps you to use pastebin services.

Requirement
-----------
- vim needs to have `+python3` compiled

Supported Feature
-----------------
- Paste current visual selection

Supported Pastebin Service
--------------------------
- [Mozilla Paste](paste.mozilla.org) *default*
- [dpaste.org](https://dpaste.org/)

Usage
-----
- Paste visual selection
`xnoremap <leader>ps :<C-U>PastebinPaste<cr>` - `<C-U>` is required to clear
the `'<,'>` from the command.

Customization
-------------
- Change the service provider
`let g:enabled_pastebin_service = "mozilla"`


