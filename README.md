## Different rankings made using PCBR for demo purposes

See the resulting rankings here: https://nakilon.github.io/pcbr-demo/  
This is for demo purposes of https://github.com/Nakilon/pcbr

### (development note) How to update

Some `.txt` files in this repo are updated manually.  
Some are updated programmatically:  
  ```none
  ## "The most developed loot management in video games"
  # update the Google Spreadsheet
  $ ruby loot.rb > loot.txt
  ```
  ```none
  ## Rimworld textiles
  # sort the <table> by name and copypaste from wiki to textiles.html
  $ bundle exec ruby textiles.rb
  ```
  ```none
  ## LoL TFT champions
  $ bundle exec ruby lol.rb
  ```
  ```none
  ## Ruby Web App Frameworks
  $ bundle exec ruby ruby-web.rb
  ```
To preview the effect, according to `main.yaml` workflow:
```none
$ ruby main.rb
$ yfm -i ./yfm -o ./out -s
$ open ./out/....html
```
Then after you push the .txt changes GitHub Action will automatically compile the single-page `index.md`, YFM docs and deploy them as GitHub Pages.
