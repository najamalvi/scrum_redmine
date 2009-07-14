# redMine - project management software
# Copyright (C) 2006-2008  Jean-Philippe Lang
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

require "#{File.dirname(__FILE__)}/../test_helper"

class ApplicationTest < ActionController::IntegrationTest
  fixtures :users
  
  def test_set_localization
    Setting.default_language = 'en'
    
    # a french user
    get 'projects', { }, 'Accept-Language' => 'fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3'
    assert_response :success
    assert_tag :tag => 'h2', :content => 'Projets'
    assert_equal 'fr', User.current.language
    
    # then an italien user
    get 'projects', { }, 'Accept-Language' => 'it;q=0.8,en-us;q=0.5,en;q=0.3'
    assert_response :success
    assert_tag :tag => 'h2', :content => 'Progetti'
    assert_equal 'it', User.current.language
    
    # not a supported language: default language should be used
    get 'projects', { }, 'Accept-Language' => 'zz'
    assert_response :success
    assert_tag :tag => 'h2', :content => 'Projects'
  end
end
