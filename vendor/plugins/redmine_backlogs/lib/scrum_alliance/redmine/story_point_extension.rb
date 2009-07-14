module ScrumAlliance
  module Redmine
    module StoryPointExtension
      module Issue
        def story_points
          story_point_value = custom_values.detect {|cv| cv.custom_field_id == 2 }
          story_point_value ? story_point_value.value.to_f : 0
        end
      end # Issue
      
      module Version
        def story_points
          fixed_issues.map(&:story_points).sum
        end
      end # Version
    end # RankExtension
  end # Redmine
end # ScrumAlliance