module ScrumAlliance
  module Redmine
    module ClosingOutExtension
      def self.included(klass)
        klass.class_eval do
          before_save :set_percent_done_when_status_is_closed
        end
      end
    
    private
      def set_percent_done_when_status_is_closed
        return true unless status_id_changed?

        self.done_ratio = 100 if status(true).is_closed?
        true
      end
    end # ClosingOutExtension
  end # Redmine
end # ScrumAlliance