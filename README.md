Vim PasteBins
=============
A vim plugin that helps you to use pastebin services.

Supported Feature
-----------------
- Paste current visual selection

Supported Pastebin Service
--------------------------
- [Mozilla Paste](paste.mozilla.org) *default*
- [dpaste.org](https://dpaste.org/)

Usage
-----
`xnoremap <leader>ps :<C-U>PastebinPaste<cr>` - `<C-U>` is required to clear
the `'<,'>` from the command.

Customization
-------------
* Change the service provider
`let g:enabled_pastebin_service = "mozilla"`


