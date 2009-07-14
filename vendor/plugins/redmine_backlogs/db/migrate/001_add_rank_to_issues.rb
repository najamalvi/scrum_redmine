# Use rake db:migrate_plugins to migrate installed plugins
class AddRankToIssues < ActiveRecord::Migration
  def self.up
    change_table :issues do |table|
      table.integer :rank, :default => 0
    end
    update "update issues set rank = id"
  end

  def self.down
    change_table :issues do |t|
      t.remove :rank
    end
  end
end