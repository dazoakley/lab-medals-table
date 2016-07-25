module LAB
  class HtmlTableBuilder
    class << self
      def build
        [
          header_start,
          header_competitions,
          '       </tr>',
          '       <tr>',
          header_medal_sections,
          '       </tr>',
          '       <tr>',
          header_medals,
          '       </tr>',
          '     </thead>',
          '     <tbody>',
          brewer_rows,
          '     </tbody>',
          '    </table>',
          '  </body>',
          '</html>'
        ].join("\n")
      end

      private

      def competitions
        LAB::DataLoader.competitions
      end

      def header_start
        <<TXT
<html>
  <head>
    <style type="text/css">
      html {
        font-family: "Open Sans", "Helvetica Neue", Arial, Helvetica, Geneva, sans-serif;;
      }
      table { border-collapse: collapse; text-align: center; }
      th,td { border: 1px solid grey; padding: 2px 4px; }
      .totals   { background-color: #F0F0F0; }
      tbody tr:hover, tbody tr:hover .totals  { background-color: #DAF7A6; }
      td.gold   { background-color: gold !important; }
      td.silver { background-color: silver !important; }
      td.bronze { background-color: #CD7F32 !important; }
    </style>
  <head>
  <body>
    <table>
      <thead>
        <tr>
          <th rowspan="3">Rank</th>
          <th rowspan="3">Member</th>
          <th rowspan="3" class="totals">Medal Points</th>
          <th colspan="6" class="totals">Total Medals</th>
TXT
      end

      def header_competitions
        competitions.map do |competition|
          %(          <th colspan="6">#{competition['year']} - #{(competition['abbr_name'] || competition['full_name'])}</th>)
        end.join("\n")
      end

      def header_medal_sections
        count = 1
        (competitions.count + 1).times.map do
          css_class = count == 1 ? ' class="totals"' : ''
          data      = [
            %(         <th colspan="3"#{css_class}>Flight&nbsp;Medals</th>),
            %(         <th colspan="3"#{css_class}>BOS&nbsp;Medals</th>)
          ]

          count += 1
          data
        end.flatten.join("\n")
      end

      def header_medals
        count = 1
        (competitions.count + 1).times.map do
          css_class = count == 1 ? ' class="totals"' : ''
          data      = 2.times.map do
            [
              %(         <th#{css_class}>G</th>),
              %(         <th#{css_class}>S</th>),
              %(         <th#{css_class}>B</th>)
            ]
          end.join("\n")

          count += 1
          data
        end.flatten.join("\n")
      end

      def brewer_rows
        html = []

        LAB::DataLoader.sorted_brewers.each do |obj|
          brewer_name = obj[0]
          rank        = obj[1]
          brewer      = LAB::DataLoader.brewers[brewer_name]

          row = [
            '       <tr>',
            "         <td>#{rank}</td>",
            "         <td>#{brewer_name.sub(' ', '&nbsp;')}</td>",
            "         <td class=\"totals\">#{brewer['score']}</td>"
          ]

          row << "         #{medal_data_cells(brewer, total_count: true)}"

          competitions.each do |competition|
            data = competition['winners'].find { |details| details['name'] == brewer_name } || {}
            row << "         #{medal_data_cells(data)}"
          end

          row << '       </tr>'

          html << row
        end

        html.flatten.join("\n")
      end

      def medal_data_cells(data, total_count: false)
        LAB.sections.map do |section|
          LAB.medals.map do |medal|
            count = data.fetch(section, {}).fetch(medal, [])
            medal_count_cell(medal, count, total_count: total_count)
          end.join('')
        end.join('')
      end

      def medal_count_cell(medal, medaling_beers, total_count: false)
        css_classes = []
        css_classes << 'totals' if total_count
        css_classes << medal if medaling_beers.any?

        css_class = css_classes.any? ? %( class="#{css_classes.join(' ')}") : ''

        if medaling_beers.empty?
          "<td#{css_class}></td>"
        else
          %(<td#{css_class}>#{medaling_beers.count}</td>)
        end
      end
    end
  end
end
