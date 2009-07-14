module ScrumAlliance
  module Redmine
    module RankExtension
      def self.included(klass)
        klass.class_eval do
          acts_as_list :column => 'rank'
        end
      end
    end # RankExtension
  end # Redmine
end # ScrumAlliance