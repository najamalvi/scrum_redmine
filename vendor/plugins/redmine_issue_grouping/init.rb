require 'redmine'

require_dependency 'issue_grouping_listener'

Redmine::Plugin.register :redmine_issue_grouping do
  name 'Redmine Issue Grouping plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
end
