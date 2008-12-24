class <%= controller_class_name %>Controller < ApplicationController
  
  def index
    complete_must = (params[:complete_must] && params[:complete_must] == 'true') ? true : false
    respond_to do |format|
      format.html 
      format.js do 
        @node = <%= model_class_name %>.find params[:id]
        
        render :update do |page|
          child_category = <%= model_class_name %>.child_category(params[:category])
          if child_category
            page.replace_html "#{params[:name]}-#{child_category}", 
                              <%= model_file_name %>_node_select(params[:name], child_category, @node.children, nil, complete_must)
            page.show "#{params[:name]}_#{child_category}_add_link"
            <%= model_class_name %>::CATEGORIES.reverse.each do |category|
              break if category == child_category
              page.replace_html "#{params[:name]}-#{category}", <%= model_file_name %>_node_select(params[:name], category, [], nil, complete_must)
              page.hide "#{params[:name]}_#{category}_add_link"
            end
          end
          
          <%= model_class_name %>::CATEGORIES.each do |category|
            page.hide "#{params[:name]}_#{category}_add"
          end
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.js do 
        render :update do |page|
          <%= model_class_name %>::CATEGORIES.reverse.each do |category|
            break if category == params[:category]
          
            page.replace_html "#{params[:name]}-#{category}", <%= model_file_name %>_node_select(params[:name], category, [], nil, complete_must)
            page.hide "#{params[:name]}_#{category}_add_link"
          end
          
          <%= model_class_name %>::CATEGORIES.each do |category|
            page.hide "#{params[:name]}_#{category}_add"
          end
        end
      end
    end
  end
  
  def create
    return if params[:category].blank? || params[:name].blank?
    
    complete_must = (params[:complete_must] && params[:complete_must] == 'true') ? true : false
  
    respond_to do |format|
      format.js do
        
        render :update do |page|
          if params[:parent_id]
            @parent = <%= model_class_name %>.find(params[:parent_id])
            node = <%= model_class_name %>.new :name => params[:node], :parent_id => params[:parent_id], :category => params[:category]
            @parent.children << node if node.valid?
            
            page.replace_html "#{params[:name]}-#{params[:category]}", 
                              <%= model_file_name %>_node_select(params[:name], params[:category], @parent.children, nil, complete_must)
            
            <%= model_class_name %>::CATEGORIES.reverse.each do |category|
              break if category == params[:category]
              
              page.replace_html "#{params[:name]}-#{category}", <%= model_file_name %>_node_select(params[:name], category, [], nil, complete_must)
              page.hide "#{params[:name]}_#{category}_add_link"
            end
          else
            <%= model_class_name %>.create :name => params[:node], :category => params[:category]
            
            page.replace_html "#{params[:name]}-#{params[:category]}", 
                              <%= model_file_name %>_node_select(params[:name], params[:category], <%= model_class_name %>.roots, nil, complete_must)
          end
          
          <%= model_class_name %>::CATEGORIES.each do |category|
            page.hide "#{params[:name]}_#{category}_add"
          end
        end
      end
    end
  end
  
end
