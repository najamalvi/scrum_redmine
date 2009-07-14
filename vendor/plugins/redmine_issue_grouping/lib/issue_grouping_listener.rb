class IssueGroupingListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    stylesheet_link_tag('issue_grouping', :plugin => 'redmine_issue_grouping')
  end
end