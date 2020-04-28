# frozen_string_literal: true

require 'mail'

class Email < ApplicationRecord
  has_many :links
  Symbols = {
    'jsw@peterc.org' => :java_weekly,
    'vgr@ribbonfarm.com' => :breaking_smart,
    'newsletter@elixirweekly.net' => :elixir_weekly,
    'kale@hackernewsletter.com' => :hacker_newsletter,
    'rw@peterc.org' => :ruby_weekly,
    'lex@sreweekly.com' => :sre_weekly,
    'leo.barbosa@canonical.com' => :vulnerabilities,
    'marc.deslauriers@canonical.com' => :vulnerabilities,
    'nieuwsbrief@m.blendle.com' => :blendle,
    'lucas@luitjes.it' => :db_weekly,
    'dbweekly@cooperpress.com' => :db_weekly
  }.freeze

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
    url_elements = doc.search('a')
    urls = url_elements.map do |n|
      [
        n.inner_text.gsub(/\s+/, ' ').empty?,
        n.parent.parent.text.gsub(/\s+/, ' '),
        %r{^https://dbweekly.com/link\S*}.match(n.attributes['href'].value).to_s
      ]
    end
    urls = urls.reject { |link| link[0] }
    urls = urls.reject { |link| link[2] == '' }
    urls = urls.map { |link| [link[1].split(" \u2014 "), link[2]].flatten }
    urls = urls.map { |link| [link[0].lstrip, link[1], link[2]] }
    urls = urls.uniq { |link| link[0] }
    urls = urls.map do |link|
      link[2].nil? ? [link[0], 'No description', link[1]] : link
    end
  end

  def java_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url_elements = url_elements.reject { |link| link.text == 'Read on the Web' }
    url_elements = url_elements.reject do |link|
      link.children.size < 2 && link.children.first.name == 'img'
    end
    urls = url_elements.map do |n|
      [
        n.parent.parent.text.gsub(/\s+/, ' '),
        %r{^https://javascriptweekly.com/link\S*}.match(n.attributes['href'].value).to_s
      ]
    end

    urls = urls.map { |link| [link[0].lstrip, link[1]] }
    urls = urls.map { |link| [link[0].split(" \u2014 "), link[1]].flatten }
    urls = urls.map { |link| link.size < 3 ? [link[0], '', link[1]] : link }
    urls.uniq! { |link| link[0] }
  end

  def breaking_smart_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url =
      [
        'breaking smart link', 'view this email in your browser',
        url_elements[0].get_attribute('href')
      ]
  end

  def elixir_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url_elements = url_elements.select do |n|
      url = n.attributes['href'].value
      url =~ %r{^https://elixirweekly.net/i/}
    end
    urls = url_elements.map do |n|
      [
        n.parent.children[1].text,
        n.parent.children[4]&.text || '',
        n.parent.children[1].attributes['href'].value
      ]
    end
  end

  def hacker_newsletter_links
    # TODO: group links by h2 headers
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url_elements = url_elements.reject { |link| link.text.slice(0, 8) == 'comments' }
    url_elements = url_elements.reject { |link| link.text == 'hackernewsletter' }
    url_elements = url_elements.reject { |link| link.text == 'http://hackernewsletter.com' }
    url_elements = url_elements.reject { |link| link.text == 'Curpress' }
    url_elements = url_elements.reject { |link| link.text == 'last year' }
    url_elements = url_elements.select do |n|
      url = n.attributes['href'].value
      url =~ %r{^https://hackernewsletter.us1.list-manage.com/track/}
    end
    urls = url_elements.map do |n|
      [
        n.text,
        n.parent.xpath('span').nil? ? ' ' : n.parent.xpath('span').text,
        n.attributes['href'].value
      ]
    end
  end

  def ruby_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url_elements = url_elements.select do |n|
      url = n.attributes['href'].value
      url =~ %r{^https://rubyweekly.com/link/}
    end
    urls = url_elements.map do |n|
      title = n.text.gsub(/\s+/, ' ')
      description_node = n.xpath('./ancestor::p[1]').first
      description = description_node ? description_node.text.gsub(/\s+/, ' ') : ''
      [
        title,
        description,
        n.attributes['href'].value
      ]
    end
    urls = urls.reject { |link| link[0] == '' }
    urls = urls.uniq { |link| [link[1], link[2]] }
  end

  def sre_weekly_links
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    # all articles
    url_elements = doc.search('a')
    url_elements = url_elements.select do |n|
      url = n.parent.get_attribute('class') == 'sreweekly-title'
    end
    url_elements = url_elements.reject { |link| link.text == 'View on sreweekly.com' }
    urls = url_elements.map do |n|
      [
        n.parent.parent.inner_text.lstrip.gsub(/\s+/, ' '),
        ' ',
        n.attributes['href'].value
      ]
    end
    # all outages
    url_elements2 = doc.xpath('/html/body/ul/li')
    urls2 = url_elements2.map { |n| [n.text.gsub(/\s+/, ' '), ' ', n.children[0]['href']] }
    urls = urls.reject { |link| link[0].slice(0, 26) == 'A message from our sponsor' }
    urls = urls.reject { |link| link[0].slice(0, 22) == 'This email was sent to' }
    urls += urls2
  end

  def vulnerabilities_links
    html_string = Mail.new(body).text_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    url_elements = url_elements.select do |n|
      url = n.attributes['href'].value
    end
  end

  def blendle_links
    # work with Lucas
    html_string = Mail.new(body).html_part.decoded
    doc = Nokogiri::HTML.parse(html_string)
    url_elements = doc.search('a')
    urls = url_elements.map do |n|
      [
        n.parent.parent.inner_text.gsub(/\s+/, ' ').lstrip,
        ' ',
        %r{^https://open.blendle.com\S*}.match(n.attributes['href'].value).to_s
      ]
    end
    urls = urls.reject { |link| link[0] == '' }
    urls = urls.reject { |link| link[0].slice(0, 16) == 'Verzonden naar l' }
    urls = urls.reject { |link| link[0].slice(0, 27) == 'Is deze nieuwsbrief naar je' }
    urls = urls.reject { |link| link[0].slice(0, 26) == 'Elke dag onbeperkt toegang' }
    urls = urls.reject { |link| link[0] == '  ' }
    urls = urls.uniq { |link| link[2] }
  end
end
