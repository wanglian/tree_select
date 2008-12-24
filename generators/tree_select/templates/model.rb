class <%= model_class_name %> < ActiveRecord::Base
  CATEGORIES = %w{<%= categories.join(' ') %>}
  
  acts_as_tree
  
  validates_presence_of :name, :category
  validates_uniqueness_of :name, :scope => 'parent_id'
  
  def siblings(c)
    if parent.nil?
      if c == CATEGORIES.first
        return <%= model_class_name %>.find_all_by_parent_id(nil)
      else
        return []
      end
    end
    self.category == c ? parent.children : parent.siblings(c)
  end
  
  def value(c)
    return nil if self.parent.nil? && self.category != c
    self.category == c ? self.id : parent.value(c)
  end
  
  def to_s
    parent ? "#{parent.to_s} #{name}" : name
  end
  
  def self.roots
    find_all_by_parent_id(nil)
  end
  
  def self.root?(c)
    CATEGORIES.index(c) == 0
  end
  
  def self.last?(c)
    CATEGORIES.index(c) == CATEGORIES.size - 1
  end
  
  def self.parent_category(c)
    (CATEGORIES.index(c) - 1) >= 0 ? CATEGORIES.at(CATEGORIES.index(c) - 1) : nil
  end
  
  def self.child_category(c)
    CATEGORIES.index(c) == (CATEGORIES.size - 1) ? nil : CATEGORIES.at(CATEGORIES.index(c) + 1)
  end
  
end
