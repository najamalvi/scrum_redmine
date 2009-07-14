module ScrumAlliance
  module Redmine
    module CurrentVersionExtension
      def current_version
        versions.detect {|version| version.created_on.to_date <= Date.current && !version.effective_date.nil? && version.effective_date >= Date.current }
      end
    end # CurrentVersionExtension
  end # Redmine
end # ScrumAlliance
