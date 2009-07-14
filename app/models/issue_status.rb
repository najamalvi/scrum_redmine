# redMine - project management software
# Copyright (C) 2006  Jean-Philippe Lang
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class IssueStatus < ActiveRecord::Base
  before_destroy :check_integrity  
  has_many :workflows, :foreign_key => "old_status_id", :dependent => :delete_all
  acts_as_list

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30
  validates_format_of :name, :with => /^[\w\s\'\-]*$/i

  def after_save
    IssueStatus.update_all("is_default=#{connection.quoted_false}", ['id <> ?', id]) if self.is_default?
  end  
  
  # Returns the default status for new issues
  def self.default
    find(:first, :conditions =>["is_default=?", true])
  end

  # Returns an array of all statuses the given role can switch to
  # Uses association cache when called more than one time
  def new_statuses_allowed_to(role, tracker)
    new_statuses = workflows.select {|w| w.role_id == role.id && w.tracker_id == tracker.id}.collect{|w| w.new_status} if role && tracker
    new_statuses ? new_statuses.compact.sort{|x, y| x.position <=> y.position } : []
  end
  
  # Same thing as above but uses a database query
  # More efficient than the previous method if called just once
  def find_new_statuses_allowed_to(role, tracker)  
    new_statuses = workflows.find(:all, 
                                   :include => :new_status,
                                   :conditions => ["role_id=? and tracker_id=?", role.id, tracker.id]).collect{ |w| w.new_status }.compact  if role && tracker
    new_statuses ? new_statuses.sort{|x, y| x.position <=> y.position } : []
  end
  
  def new_status_allowed_to?(status, role, tracker)
    status && role && tracker ?
      !workflows.find(:first, :conditions => {:new_status_id => status.id, :role_id => role.id, :tracker_id => tracker.id}).nil? :
      false
  end

  def <=>(status)
    position <=> status.position
  end
  
  def to_s; name end

private
  def check_integrity
    raise "Can't delete status" if Issue.find(:first, :conditions => ["status_id=?", self.id])
  end
end
