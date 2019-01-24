class Email < ApplicationRecord

  def db_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        n.inner_text.gsub(/\s+/," ").empty?,
        # filtering by .parent.parent is wonky
        n.parent.parent.inner_text.gsub(/\s+/," "),
        /^https:\/\/dbweekly.com\/link\S*/.match(n.attributes["href"].value).to_s
      ]
    end
    urls = urls.select { |link| !link[0] }
    urls = urls.select { |link| link[2] != "" }
    # splitting on hardcoded unicode characters is lame
    urls = urls.map { |link| [link[1].split(" \u2014 "), link[2]].flatten }
  end

  def java_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        n.parent.parent.inner_text.gsub(/\s+/," "),
        /^https:\/\/javascriptweekly.com\/link\S*/.match(n.attributes["href"].value).to_s
      ]
    end
    urls = urls.map { |link| [link[0].split(" \u2014 "), link[1]].flatten }
    # the gsub puts a space that I cant filter out with the line below
    # also uniq doesn't work because some link names have a space at the start
    urls = urls.select { |link| link[2] != "" }
    urls = urls.uniq
    # require 'pry'; binding.pry
  end

  def breaking_smart_link
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url = [url_elements[0].inner_text, url_elements[0].attributes["href"].value]
  end

  def elixir_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select do |n|
      url = n.attributes["href"].value
      url =~ /^https:\/\/elixirweekly.net\/i\//
    end
    urls = url_elements.map do |n|
      [
        n.parent.children[1].text,
        n.parent.children[4]&.text || "",
        n.parent.children[1].attributes["href"].value
      ]
    end
  end

  def hacker_newsletter_links
    # TODO group links by h2 headers, remove comment links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select do |n|
      url = n.attributes["href"].value
      url =~ /^https:\/\/hackernewsletter.us1.list-manage.com\/track\//
    end
    urls = url_elements.map do |n|
      [
        n.text,
        n.attributes["href"].value
      ]
    end
  end

  def ruby_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select do |n|
      url = n.attributes["href"].value
      url =~ /^https:\/\/rubyweekly.com\/link\//
    end
    urls = url_elements.map do |n|
      [
        n.parent.parent.text.gsub(/\s+/," "),
        n.attributes["href"].value
      ]
    end
    urls = urls.map { |link| [link[0].split(" \u2014 "), link[1]].flatten }
    # Some links show up twice in the result
    # require 'pry'; binding.pry
    # urls
  end

  def sre_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select do |n|
      url = n.attributes["href"].value
    end
    urls = url_elements.map do |n|
      [
        n.parent.parent.inner_text.gsub(/\s+/," "),
        n.attributes["href"].value
      ]
    end
  end

  def vulnerabilities_links
    html_string = Mail.new(body).text_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select do |n|
      url = n.attributes["href"].value
    end
    url_elements
    # require 'pry'; binding.pry
  end

  def blendle_links
    # work with Lucas
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        n.parent.parent.inner_text.gsub(/\s+/," "),
        /^https:\/\/javascriptweekly.com\/link\S*/.match(n.attributes["href"].value).to_s
      ]
    end
  end
end


