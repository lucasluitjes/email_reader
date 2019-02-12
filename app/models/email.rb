require 'mail'

class Email < ApplicationRecord
  has_many :links
  Symbols = {
      "jsw@peterc.org" => :java_weekly,
      "vgr@ribbonfarm.com" => :breaking_smart,
      "newsletter@elixirweekly.net" => :elixir_weekly,
      "kale@hackernewsletter.com" => :hacker_newsletter,
      "rw@peterc.org" => :ruby_weekly,
      "lex@sreweekly.com" => :sre_weekly,
      "leo.barbosa@canonical.com" => :vulnerabilities,
      "nieuwsbrief@m.blendle.com" => :blendle
    }

  def create_links!
    send(:"#{email_list_type}_links").each do |title, description, url|
      Link.create(title: title, description: description, url: url, read: false, email: self)
    end
  end

  def email_list_type
    mail = Mail.new(body)
    sender = mail.from.first
    symbol = Symbols[sender]
  end

  def db_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        n.inner_text.gsub(/\s+/," ").empty?,
        n.parent.parent.text.gsub(/\s+/," "),
        /^https:\/\/dbweekly.com\/link\S*/.match(n.attributes["href"].value).to_s
      ]
    end
    urls = urls.select { |link| !link[0] }
    urls = urls.select { |link| link[2] != "" }
    urls = urls.map { |link| [link[1].split(" \u2014 "), link[2]].flatten }
  end

  def java_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        n.parent.parent.text.gsub(/\s+/," "),
        /^https:\/\/javascriptweekly.com\/link\S*/.match(n.attributes["href"].value).to_s
      ]
    end
    urls = urls.map { |link| [link[0].lstrip, link[1]] }
    urls = urls.uniq
    urls = urls.map { |link| [link[0].split(" \u2014 "), link[1]].flatten }
    urls = urls.select { |link| link[2] != nil }
    require 'pry';binding.pry
    urls
  end

  def breaking_smart_links
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
      title = n.text.gsub(/\s+/," ")
      description = n.parent.parent.text
      description.slice!(title)
      [
        title,
        description,
        n.attributes["href"].value
      ]
    end
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
    urls
  end
end


