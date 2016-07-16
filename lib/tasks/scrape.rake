namespace :scrape do

  task clean: :environment do
    ScrapedProduct.delete_all
    ProductMatch.delete_all
    puts "Cleanup finished"
  end

  task tv: :environment do
    original_matches = ProductMatch.count
    FravegaScraper.new.run
    WallmartScraper.new.run
    ProductMatchmaker.new.find_matches
    current_matches = ProductMatch.count
    puts "TV scrape finished: #{current_matches - original_matches} found"
  end

  task clean_run: :environment do
    Rake::Task["scrape:clean"].invoke
    Rake::Task["scrape:tv"].invoke
  end

end
