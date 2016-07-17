# Pricecompare
A minimalistic proof-of-concept of crawling two sites that sell the same type of products in different countries to find product matches and compare the prices considering the actual currency exchange.

Right now the application looks for Samsung TVs in [Fravega](http://www.fravega.com) (Argentina) and [Wallmart](http://www.walmart.com) (USA) stores.

## Getting Started

1. Clone this repository:

        $ git clone git@github.com:basicNew/pricecompare.git

2. cd in the repo. This will create the appropriate gemset if you have rvm installed.

        $ cd pricecompare

3. Install bundler if you haven't already

        $ gem install bundler

4. Install the required gems

        $ bundle install

5. Run the migrations

        $ bin/rake db:migrate

6. Run the rake task that performs the web crawling and find the matches

        $ bin/rake scrape:clean_run
        Running via Spring preloader in process 12469
        Cleanup finished
        Fetching product from http://www.fravega.com/smart-tv-samsung-32-un32j5500-501232/p [OK]
        Fetching product from http://www.fravega.com/smart-tv-samsung-40-un40j5300-501253/p [OK]
        ...
        Fetching product from http://www.walmart.com/ip/Samsung-UN50JU6500-50-4K-Ultra-HD-2160p-60Hz-LED-Smart-HDTV-4K-x-2K/44162676 [OK]
        Fetching product from http://www.walmart.com/ip/Samsung-UN40J5500-40-1080p-60Hz-LED-Smart-HDTV/44162670 [OK]
        TV scrape finished: 3 found

7. Launch the rails app

        $ bin/rails s

8. Visit `localhost:3000` and you should see the three matches found.

9. Go to the admin backend if you want to take a look at all the scraped products.

## License

[MIT](http://www.opensource.org/licenses/MIT)


