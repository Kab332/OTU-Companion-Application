# Webscraper
A python scrapy project that webscrapes Ontario Tech University's public Available Courses preview for occupied class times per term.

## Purpose:
To find occupied rooms and empty rooms on campus.

## How to use:
Simply open the project directory and run "scrapy crawl myspider" in terminal (Requires scrapy to be installed).

## Results:
A sqlite database containing 3 columns Time, Day, Location

## Notes:
To use `cloudfirestore.py`, please look into how make your own Cloud Firestore database. Requires a `servicesAccountKey.json` and the resulting sqlite database to use.
Simply run the .py to parse the sqlite database to cloud firestore.

## Examples:

![Screenshot1](https://i.imgur.com/KqYovER.png)
