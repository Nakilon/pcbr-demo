This is for demo purposes of https://github.com/Nakilon/pcbr

#### reminder for myself on how to update

Manually update .txt, optionally run:
  ```none
  $ ruby loot.rb > loot.txt   # to import changes from the corresponding Google Spreadsheet
  ```
  ```none
  $ ruby textiles.rb          # to parse the corresponding DOM node html
  ```
Then GitHub Action will automatically compile the single-page `index.md`, YFM docs and deploy them as GitHub Pages.
