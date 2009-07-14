module IssuesHelper
  def group_header(group)
    return "<span>(none)</span>" if group.blank?
    return "<span>#{group.to_s}</span>" unless group.respond_to?(:subject)

    %Q[<span>#{link_to_issue(group)}: #{group.subject}</span></td><td class="done_ratio">#{progress_bar(group.done_ratio, :width => '80px')}]
  end
  
  def group_columns_to_span(group, query)
    query.columns.size + (group.respond_to?(:subject) ? 1 : 2)
  end

  # TODO: reflect on something to generate this.
  def grouping_options(query)
    options_for_select([
      ['',''], 
      ['Author', 'author'],
      ['Assigned to', 'assigned_to'],
      ['Category', 'category'],
      ['Priority', 'priority'],
      ['Status', 'status'],
      ['Story', 'story']
    ], query.group)
  end
end