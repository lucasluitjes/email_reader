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
      "marc.deslauriers@canonical.com" => :vulnerabilities,
      "nieuwsbrief@m.blendle.com" => :blendle,
      "lucas@luitjes.it" => :db_weekly,
      "dbweekly@cooperpress.com" => :db_weekly
    }

  def create_links!
    send(:"#{email_list_type}_links").each do |title, description, url|
      Link.create(title: title, description: description, url: url, read: false, email: self)
    end
  end

  def email_list_type
    mail = Mail.new(body)
    sender = mail.from.first
    pp sender
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
    # TODO group links by h2 headers
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    url_elements = url_elements.select { |link| link.text.slice(0,8) != "comments" }
    url_elements = url_elements.select { |link| link.text != "hackernewsletter" }
    url_elements = url_elements.select { |link| link.text != "http://hackernewsletter.com" }
    url_elements = url_elements.select { |link| link.text != "Curpress" }
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
      description_node = n.xpath('./ancestor::p[1]').first
      description = description_node ? description_node.text.gsub(/\s+/," ") : ""
      [
        title,
        description,
        n.attributes["href"].value
      ]
    end
    urls.uniq { |link| [link[1], link[2]]}
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
  end

  def blendle_links
    # work with Lucas
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search("a")
    urls = url_elements.map do |n|
      [
        (n.parent.parent.inner_text.gsub(/\s+/," ")).lstrip,
        "",
        /^https:\/\/open.blendle.com\S*/.match(n.attributes["href"].value).to_s
      ]
    end
    urls = urls.select { |link| link[0] != "" }
    urls = urls.uniq
  end
end


