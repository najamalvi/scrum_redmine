class BurndownListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context={})
    stylesheet_link_tag('burndowns', :plugin => 'redmine_burndown')
  end
end