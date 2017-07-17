module LAB
  class RollOfHonourBuilder
    class << self
      def build
        competitions.map do |competition|
          CompetitionRollOfHonourBuilder.new(competition).build
        end.join("\n\n")
      end

      private

      def competitions
        LAB::DataLoader.competitions_for_roll
      end
    end
  end
end
