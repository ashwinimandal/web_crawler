class Crawler < ApplicationRecord
  require 'mechanize'

  def initializer
   
  end

  def self.process(url)
    @agent = Mechanize.new
    return false unless check_valid_domain(url)
    @origin_domain = URI.parse(url).hostname
    page = perfom_crawler(url)
    if page.present? && page.links.present?
      allocate_threads_to_next_crawl(page)
      sleep(5) # main thread sleeps for five seconds then 
      puts`clear` #clear the screen
    end
    page
  end


  def self.perfom_crawler(url)
    #agent = Mechanize.new
    res = @agent.get(url)
    if res.code.eql? '200' && res.present?
      res
    end
    res
  end

  def self.allocate_threads_to_next_crawl(page)
    mutex = Mutex.new
    threads = []

    page.links.each do |p_link|
      threads << Thread.new(p_link){
          domain_name = URI.parse(p_link.href).hostname
          if domain_name.present? #&& @origin_domain.eql? domain_name
            puts "text-->#{p_link.text} AND href-->#{p_link.href}"
            process(p_link.href)
          end
        }

      mutex.synchronize do
        file = File.open("history.txt", "a")
        file.puts "#{p_link.text}: #{p_link.href}"
        file.close
      end

      # after every thread is done, close the main thread.
      threads.each { |aThread| aThread.join }
    end
  end

 
  def self.check_valid_domain(url)
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
    rescue URI::InvalidURIError
      false
  end
end
 