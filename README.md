
# Gina's Emacs Setup 💽

This is my Emacs Init file for OSX (could be tweaked for Linux or Windows).
A series of Copypastas and works in progress, lovingly dumped without order or care into one large elisp file.

I've included a [help yourself](./help_yourself.md) file that has a cheatsheet for keybindings and links to documentation for the packages I've used here. 

## Caveats ⚠️

I hacked the dashboard lisp locally to get my colors for the dashboard. Just use `M-x customize-face` and then search for the `Dashboard` group. You can click to go to definition in the elisp for whatever font-color you'd like, for example: 

```elisp
(defface dashboard-heading
  '((t (:weight ultra-light :foreground "hotpink")))
  "Face used for widget headings."
  :group 'dashboard)

```

## Known Issues 👾

- `eglot` server issues for FSharp 
- export from `latex` or `pdf` not working on OSX
- export markdown not working on OSX

I've also locally hacked by `Minimap` mode so it's background color is purple 💟

## Contributing or Forking 🍝

Feel free to PR something nice if you wanna remix.
Copypasta or fork, go ahead!

