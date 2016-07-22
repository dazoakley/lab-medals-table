#!/usr/bin/env ruby

require 'yaml'
require 'pry'

# Scores awarded for each medal
SCORES = {
  'flight' => {
    'gold'   => 10,
    'silver' => 5,
    'bronze' => 2.5
  },
  'bos'    => {
    'gold'   => 20,
    'silver' => 10,
    'bronze' => 5
  }
}.freeze

def competitions
  @competitions ||=
    Dir['data/*.yaml']
    .map     { |file| YAML.load(File.read(file)) }
    .sort_by { |data| [data['year'], data['competition']].join('-') }
    .reverse
end

def new_brewer_data
  {
    'flight' => { 'gold' => 0, 'silver' => 0, 'bronze' => 0 },
    'bos'    => { 'gold' => 0, 'silver' => 0, 'bronze' => 0 }
  }
end

def brewers
  @brewers ||= begin
                 memo = {}

                 competitions.each do |comp|
                   comp['winners'].each do |data|
                     brewer = memo[data['name']] ||= new_brewer_data.dup

                     %w(flight bos).each do |section|
                       medals = data[section]

                       next unless medals

                       medals.each do |medal, count|
                         brewer[section][medal] += count
                       end
                     end
                   end
                 end

                 memo.each { |brewer, medals| memo[brewer]['score'] = calc_score(medals) }

                 memo
               end
end

def sorted_brewers
  @sorted_brewers ||= begin
    memo  = []
    names = brewers.sort_by { |_brewer, data| data['score'] }.reverse.map(&:first)

    names.each_with_index do |name, index|
      if index == 0
        memo << [name, index + 1]
      else
        score      = brewers[name]['score']
        prev_score = brewers[names[index - 1]]['score']
        rank       = score == prev_score ? '=' : index + 1

        memo << [name, rank]
      end
    end

    memo
  end
end

def calc_score(medals)
  score = 0

  medals.each do |section, medal_counts|
    medal_counts.each do |place, count|
      score += (SCORES.fetch(section).fetch(place) * count)
    end
  end

  score
end

def html_table
  html = <<TXT
<html>
  <head><head>
  <body>
    <table>
      <thead>
        <tr>
          <th rowspan="3">Rank</th>
          <th rowspan="3">Member</th>
          <th rowspan="3">Medal Points</th>
          <th colspan="6">Total Medals</th>
TXT
  competitions.each do |competition|
    html << %(          <th colspan="6">#{competition['year']} - #{competition['competition']}</th>\n)
  end

  html << %(       </tr>\n)
  html << %(       <tr>\n)

  (competitions.count +1).times do
    html << %(         <th colspan="3">Flight Medals</th>\n)
    html << %(         <th colspan="3">BOS Medals</th>\n)
  end

  html << %(       </tr>\n)
  html << %(       <tr>\n)

  (competitions.count + 1).times do
    html << %(         <th>Gold</th>\n)
    html << %(         <th>Silver</th>\n)
    html << %(         <th>Bronze</th>\n)
    html << %(         <th>Gold</th>\n)
    html << %(         <th>Silver</th>\n)
    html << %(         <th>Bronze</th>\n)
  end

  html << %(       </tr>\n)
  html << %(     </thead>\n)
  html << %(     <tbody>\n)

  sorted_brewers.each do |obj|
    brewer_name = obj[0]
    rank        = obj[1]
    brewer      = brewers[brewer_name]

    html << %(  <tr>
    <td>#{rank}</td>
    <td>#{brewer_name}</td>
    <td>#{brewer['score']}</td>
)

    html << medal_data_cells(brewer)

    competitions.each do |competition|
      data = competition['winners'].find { |details| details['name'] == brewer_name } || {}
      html << medal_data_cells(data)
    end

    html << "  </tr>\n"
  end

  html << %(      </tbody>\n)
  html << %(    </table>\n)
  html << %(  </body>\n)
  html << %(</html>\n)

  html
end

def medal_data_cells(data)
  text = '    '

  %w(flight bos).each do |section|
    %w(gold silver bronze).each do |medal|
      count = data.fetch(section, {}).fetch(medal, 0)
      text << medal_count_cell(medal, count)
    end
  end

  text + "\n"
end

def medal_count_cell(medal, count)
  if count.zero?
    '<td></td>'
  else
    %(<td class="#{medal}">#{count}</td>)
  end
end

puts html_table
