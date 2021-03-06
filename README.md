Vim Pastebins
=============
A vim plugin that helps you to use pastebin services, inspired by [webpaste.el](https://github.com/etu/webpaste.el).

Requirement
-----------
- vim needs to have `+python3` compiled

Supported Feature
-----------------
- Paste current visual selection
- Paste the entire buffer
- List previously posted pastes

Supported Pastebin Service
--------------------------
- [Mozilla Paste](paste.mozilla.org) *default*
- [dpaste.org](https://dpaste.org/)

Usage
-----
- Paste Visual Selection
`<C-U>PastebinPaste` - `<C-U>` is required to clear the `'<,'>` from the command.

- Paste the entire buffer
`PastebinPasteAll`

- List Previous Posted Pastes
`PastebinPasteList`


Customization
-------------
- Change the service provider
`let g:enabled_pastebin_service = "mozilla"`

