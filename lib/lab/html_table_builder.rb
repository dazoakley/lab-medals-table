module LAB
  class HtmlTableBuilder
    class << self
      def build
        [
          header_start,
          header_competitions,
          header_row_end_start,
          header_medal_sections,
          header_row_end_start,
          header_medals,
          %(       </tr>),
          %(     </thead>),
          %(     <tbody>),
          brewer_rows,
          %(     </tbody>),
          %(    </table>),
          %(  </body>),
          %(</html>)
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
      tr:hover  { background-color: #DAF7A6; }
      td.gold   { background-color: gold; }
      td.silver { background-color: silver; }
      td.bronze { background-color: #CD7F32; }
    </style>
  <head>
  <body>
    <table>
      <thead>
        <tr>
          <th rowspan="3">Rank</th>
          <th rowspan="3">Member</th>
          <th rowspan="3">Medal Points</th>
          <th colspan="6">Total Medals</th>
TXT
      end

      def header_competitions
        competitions.map do |competition|
          %(          <th colspan="6">#{competition['year']} - #{competition['competition']}</th>)
        end.join("\n")
      end

      def header_row_end_start
        [
          '       </tr>',
          '       <tr>'
        ].join("\n")
      end

      def header_medal_sections
        (competitions.count + 1).times.map do
          [
            %(         <th colspan="3">Flight&nbsp;Medals</th>),
            %(         <th colspan="3">BOS&nbsp;Medals</th>)
          ]
        end.flatten.join("\n")
      end

      def header_medals
        (competitions.count + 1).times.map do
          2.times.map do
            [
              %(         <th>G</th>),
              %(         <th>S</th>),
              %(         <th>B</th>)
            ]
          end.join("\n")
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
            "         <td>#{brewer['score']}</td>"
          ]

          row << "         #{medal_data_cells(brewer)}"

          competitions.each do |competition|
            data = competition['winners'].find { |details| details['name'] == brewer_name } || {}
            row << "         #{medal_data_cells(data)}"
          end

          row << '       </tr>'

          html << row
        end

        html.flatten.join("\n")
      end

      def medal_data_cells(data)
        LAB.sections.map do |section|
          LAB.medals.map do |medal|
            count = data.fetch(section, {}).fetch(medal, 0)
            medal_count_cell(medal, count)
          end.join('')
        end.join('')
      end

      def medal_count_cell(medal, count)
        if count.zero?
          '<td></td>'
        else
          %(<td class="#{medal}">#{count}</td>)
        end
      end
    end
  end
end
