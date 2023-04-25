
# Gina's Emacs Setup 💽

This is my Emacs Init file for OSX (could be tweaked for Linux or Windows). 
A series of Copypastas and works in progress, lovingly dumped without order or care into one large elisp file.

I've included a [help yourself](./help_yourself.md) file that has a cheatsheet for keybindings and links to documentation for the packages I've used here. 

Image gif in Dashboard was made by [u/Meowmarlade](https://www.reddit.com/user/Meowmarlade/). You do not have the right to take this and use it for profit or claim it was your own.
 
<img width="1721" alt="Screenshot 2023-04-23 at 8 46 04 pm" src="https://user-images.githubusercontent.com/3818802/233836832-f52f58c9-f696-4645-8326-0659b865ea0d.png">

<img width="1728" alt="Screenshot 2023-04-23 at 9 02 51 pm" src="https://user-images.githubusercontent.com/3818802/233836818-e7f9b697-657d-4164-95e5-ad6a1ee726dd.png">

## Caveats ⚠️

I hacked the dashboard lisp locally to get my colors for the dashboard. Just use `M-x customize-face` and then search for the `Dashboard` group. You can click to go to definition in the elisp for whatever font-color you'd like, for example: 

```elisp
(defface dashboard-heading
  '((t (:weight ultra-light :foreground "hotpink")))
  "Face used for widget headings."
  :group 'dashboard)

```

I've also locally hacked by `Minimap` mode so its background color on the viewer is purple 💟

## Known Issues 👾

- `eglot` server issues for FSharp 
- export from `latex` or `pdf` not working on OSX
- export markdown not working on OSX

## Contributing or Forking 🍝

Feel free to PR something nice if you wanna remix.
Copypasta or fork, go ahead!

