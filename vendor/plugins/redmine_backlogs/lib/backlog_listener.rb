class TaskBoardListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    stylesheet_link_tag('backlogs', :plugin => 'redmine_backlogs') + 
      javascript_include_tag('context_menu') + 
      stylesheet_link_tag('context_menu') +
      javascript_include_tag('backlogs', :plugin => 'redmine_backlogs')
  end
end