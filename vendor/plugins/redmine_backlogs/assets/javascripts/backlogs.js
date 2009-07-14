var ScrumAlliance = ScrumAlliance || {};

ScrumAlliance.Backlog = Class.create({
  initialize: function(containerElementId, backlogTitle) {
    this.containerElement = $(containerElementId);
    this.backlogTitle = backlogTitle;
    
    var dataUrl = this.containerElement.readAttribute('data-url')    
    Ajax.Responders.register({ onComplete: this._backlogLoaded.bind(this) });
    
    new Ajax.Updater(this.containerElement, dataUrl, { asynchronous: true, evalScripts: true, method: 'GET' });
     // , onComplete: this._backlogLoaded.bind(this) }
  },
  
  _backlogLoaded: function() {
    this.containerElement.down('h2').update(this.backlogTitle);
  }
});

ScrumAlliance.SprintBacklog = Class.create(ScrumAlliance.Backlog, {
  initialize: function($super, containerElementId, backlogTitle) {
    $super(containerElementId, backlogTitle);
    this.containerElement.addClassName('sprint_backlog');
  },
  
  _backlogLoaded: function($super) {
    $super();
    this._setupContextualLinks();
  },
  
  _setupContextualLinks: function() {
    allLink = new Element('a', { 'class': 'icon', href: this.containerElement.readAttribute('data-url') }).update("All");
    allLink.observe('click', this._loadContent.bind(this));
    
    openLink = new Element('a', { 'class': 'icon', href: this.containerElement.readAttribute('data-open-url') }).update("Open");
    openLink.observe('click', this._loadContent.bind(this));
    
    contextualLinks = new Element('div', { 'class': 'contextual' });
    contextualLinks.appendChild(allLink);
    contextualLinks.appendChild(openLink);
    
    this.containerElement.down('h2').insert({ before: contextualLinks });
  },
  
  _loadContent: function(event) {
    new Ajax.Updater('content', event.element().readAttribute('href'))
    event.stop();
  }
});

ScrumAlliance.ProductBacklog = Class.create(ScrumAlliance.Backlog, {
  initialize: function($super, containerElementId, backlogTitle) {
    $super(containerElementId, backlogTitle);
    this.containerElement.addClassName('product_backlog');
  },
  
  _backlogLoaded: function($super) {
    $super();
    if (!this._setupNeeded()) { return; }
    
    this.containerElement.down("thead tr").innerHTML += "<th>&nbsp;</th>";
    $$("#issue_list tr[class!~issue_list_group_heading]").each(function(el) {
      cell = new Element('td').update('&nbsp;')
      if (!el.hasClassName('issue_list_group_heading')) { cell.addClassName('rank_handle') }
      
      el.appendChild(cell);
    });
    
    Sortable.create("issue_list", {
      tag: 'tr', format: /^[^_]*-(.*)$/,containment: 'issue_list', 
      handle: 'rank_handle',
      constraint: 'vertical',
      hoverclass: 'sort_hover',
      
      onChange: function(element) {
        this.draggedElement = element;
      }.bind(this),
      
      onUpdate: function(container) {
        var prioritizeUrl = this.containerElement.readAttribute('data-prioritize-url')
        new Ajax.Request(prioritizeUrl, { parameters: Sortable.serialize(container) + "&dragged_id=" + this.draggedElement.id });
      }.bind(this),
      
      starteffect: function(element) {
        element._originalBackground = element.getStyle('background-color');
        element.setStyle({background: '#FEFF9F'});
      },
      
      endeffect: function(element) { 
        element.setStyle({background: (element._originalBackground || '#fff')});
      }
    });
  },
  
  _setupNeeded: function() { 
    return $$("#issue_list tr td.rank_handle").size() <= 0;
  }
});