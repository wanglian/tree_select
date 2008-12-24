module <%= controller_class_name %>Helper
  def <%= model_file_name %>_node_select(name, category, options, value, complete_must)
    select_tag("#{name}_#{category}", "<option>--- Please Select ---</option>#{options_for_select(options.collect {|c| [c.name, c.id]}, value)}",
          {:onchange => remote_function(:url => {:controller => "<%= controller_file_name %>", :name => name, 
                                                 :category => category, :complete_must => complete_must}, 
                                        :with => "'id=' + this.value", :method => :get,
                                        :before => "Element.show('spinner-#{name}-#{category}')",
                                        :success => "Element.hide('spinner-#{name}-#{category}'); 
                                                    #{<%= model_file_name %>_callback_success(name, category, complete_must)}"), 
          :style => 'width:180px;'})
  end
  
  def <%= model_file_name %>_spinner_image_tag(id)
    image_tag("tree-spinner.gif",
              :align => "top",
              :border => 0,
              :id => id,
              :style =>"display: none;height:15px;" )
  end
  
  def <%= model_file_name %>_select(name, value=nil, opts={})
    opts[:readonly] ||= false
    opts[:complete_must] ||= false
    render :partial => '<%= controller_file_name %>/<%= model_file_name %>_select', 
           :locals => {:name => name, :value => value, :readonly => opts[:readonly], :complete_must => opts[:complete_must]}
  end
  
  def with_params_for_create_<%= model_file_name %>(name, category)
    params = "'node=' + $F('#{name}_#{category}_name')"
    params << " + '&parent_id=' + $F('#{name}_#{<%= model_class_name %>.parent_category(category)}')" unless <%= model_class_name %>.root?(category)
    params
  end
  
  private
  def <%= model_file_name %>_callback_success(name, category, complete_must)
    complete_must ? 
      (<%= model_class_name %>.last?(category) ? "$('#{name}').value=$F('#{name}_#{category}');" : "$('#{name}').value='';") :
      "$('#{name}').value=$F('#{name}_#{category}');"
  end
  
end
