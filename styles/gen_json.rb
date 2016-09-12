#! /usr/bin/env ruby

require 'nokogiri'
require 'json'
require 'titleize'
require 'pry'

xml  = File.open("#{ARGV[0]}.xml") { |f| Nokogiri::XML(f) }
json = { name: 'Styles', children: [] }

xml.xpath('//class').each do |c|
  class_json = { name: c['type'].titleize, children: [] }

  c.xpath('./category').each do |cat|
    cat_json = {
      name:     cat.xpath('./name').first.content.strip,
      number:   cat['id'],
      children: []
    }

    cat.xpath('./subcategory').each do |subcat|
      cat_json[:children] << {
        name:   subcat.xpath('./name').first.content.strip,
        letter: subcat['id'].sub(cat['id'], '')
      }
    end

    cat_json.delete(:children) if cat_json[:children].size == 1

    class_json[:children] << cat_json
  end

  json[:children] << class_json
end

File.open("#{ARGV[0]}.json", 'w') do |file|
  file.write JSON.pretty_generate(json)
end
