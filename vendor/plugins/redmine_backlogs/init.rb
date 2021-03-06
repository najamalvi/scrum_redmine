require 'redmine'

require_dependency 'backlog_listener'
require_dependency 'scrum_alliance/redmine/rank_extension'
require_dependency 'scrum_alliance/redmine/story_point_extension'
require_dependency 'scrum_alliance/redmine/closing_out_extension'

require 'dispatcher'
Dispatcher.to_prepare do
  Issue.class_eval { include ScrumAlliance::Redmine::ClosingOutExtension }
  
  Issue.class_eval { include ScrumAlliance::Redmine::RankExtension }
  Query.available_columns << QueryColumn.new(:rank, :sortable => "#{Issue.table_name}.rank")
  
  Issue.class_eval { include ScrumAlliance::Redmine::StoryPointExtension::Issue }
  Version.class_eval { include ScrumAlliance::Redmine::StoryPointExtension::Version }  
end
 
Redmine::Plugin.register :redmine_backlog do
  name 'Redmine Backlogs plugin'
  author 'Dan Hodos'
  description "Adds 'Sprint Backlog' and 'Product Backlog' tabs"
  version '1.1.1'
  
  project_module :sprint_backlogs do
    permission :sprint_backlog, {:backlogs => [:sprint]}, :public => true
  end
  
  Redmine::MenuManager.map :project_menu do |menu|
    menu.delete :overview
    menu.delete :roadmap
    menu.delete :issues
    menu.delete :new_issue
  end
  
  permission :view_product_backlog, {:backlogs => [:product]}, :public => true
  permission :prioritize_product_backlog, {:backlogs => [:prioritize]}
  
  #menu :application_menu, :product_backlog, {:controller => 'backlogs', :action => 'product'}, :caption => 'Product Backlog'
  menu :project_menu, :product_backlog, {:controller => 'backlogs', :action => 'product'}, :caption => 'Product Backlog', :first => true
  
  menu :project_menu, :sprint_backlog, {:controller => 'backlogs', :action => 'sprint'}, :after => :product_backlog, :caption => 'Sprint Backlog'
end
