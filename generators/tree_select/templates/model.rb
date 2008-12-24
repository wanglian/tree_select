class <%= model_class_name %> < ActiveRecord::Base
  CATEGORIES = %w{<%= categories.join(' ') %>}
  
  acts_as_tree
  
  validates_presence_of :name, :category
  validates_uniqueness_of :name, :scope => 'parent_id'
  
  def subs(category)
    (category.nil? || CATEGORIES.index(category) == 0) ? <%= model_class_name %>.find_all_by_parent_id(nil) : (parent.nil? ? [] : parent.children)
  end
  
  def self.roots
    find_all_by_parent_id(nil)
  end
  
  def self.root?(category)
    CATEGORIES.index(category) == 0
  end
  
  def self.last?(category)
    CATEGORIES.index(category) == CATEGORIES.size - 1
  end
  
  def self.parent_category(category)
    (CATEGORIES.index(category) - 1) >= 0 ? CATEGORIES.at(CATEGORIES.index(category) - 1) : nil
  end
  
  def self.child_category(category)
    CATEGORIES.index(category) == (CATEGORIES.size - 1) ? nil : CATEGORIES.at(CATEGORIES.index(category) + 1)
  end
  
end
