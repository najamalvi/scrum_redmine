class VelocityChart
  unloadable
  
  attr_accessor :project
  delegate :to_s, :to => :chart
  
  def initialize(project)
    self.project = project
  end
    
  def chart
    Gchart.bar({
      :size => '180x140', 
      :data => story_points,
      :axis_with_labels => 'y',
      :axis_labels => axis_labels.join('|'),
      :custom => "chm=#{data_labels.join('|')}",
      :background => "EEEEEE",
      :title => "Velocity", :title_size => 11
    })
  end
  
  def story_points
    @story_points ||= project.versions.all.reverse.last(5).map(&:story_points)
  end
    
  def axis_labels
    labels = (0..story_points.max).step(10)
    labels << (labels.max + 10)    
  end
  
  def data_labels
    idx = 0
    story_points.map do |sp| 
      str = "t#{sp},000000,0,#{idx},10"
      idx += 1
      str
    end
  end
end