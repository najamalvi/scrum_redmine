module IssuesHelper
  def self.included(klass)
    klass.class_eval do
      alias_method_chain :css_issue_classes, :tracker_name
    end
  end
  
  def css_issue_classes_with_tracker_name(issue)
    "#{css_issue_classes_without_tracker_name(issue)} type-#{issue.tracker.name.downcase}"
  end
end