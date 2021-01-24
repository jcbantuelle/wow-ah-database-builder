# Purpose

For a Private WoW Server, the Auction House is disappointingly empty. Most variants provide an AH Bot that can automatically post items and simulate a server economy, however you need to preload the bot with a list of items to post.

This script takes a CSV file containing an exhaustive list of items and filters it down into only those that should be posted on the AH. The output is a new CSV file that can be painlessly imported into the expectant AH bot database table.

# Usage

This project is intended to be run via [Docker](https://www.docker.com/). Once it's installed, you need to build and run the project:

```
docker build -t ah-database .
docker run -v "$PWD":/usr/src/app -w /usr/src/app ah-database
```

This will produce `ah-items.csv` for import into your AH database.

# Customizing

`wow-items-db.csv` contains a list of items in the format `[id, name]`. Adjust accordingly to suit your own needs or replace entirely with a new file that matches that format.

`build-ah-database.rb` is the script that applies filter criteria to the full item list and generates `ah-items.csv`. Adjust accordingly to suit your own needs.
