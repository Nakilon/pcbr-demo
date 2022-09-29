## Different rankings made using PCBR for demo purposes

See the resulting rankings here: https://nakilon.github.io/pcbr-demo/  
This is for demo purposes of https://github.com/Nakilon/pcbr

### reminder for myself on how to update

Some `.txt` files are updated manually.  
Some are updated programmatically:
  ```none
  ## "The most developed loot management in video games"
  # update the Google Spreadsheet
  $ ruby loot.rb > loot.txt
  ```
  ```none
  ## Rimworld textiles
  # copypaste the <table> from wiki to textiles.html
  $ bundle install && bundle exec ruby textiles.rb
  ```
Then after you mush the txt changes GitHub Action will automatically compile the single-page `index.md`, YFM docs and deploy them as GitHub Pages.
