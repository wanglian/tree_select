class TreeSelectGenerator < Rails::Generator::NamedBase
  attr_reader :name, :model_file_name, :model_class_name, :controller_file_name, :controller_class_name, :categories
  
  def initialize(runtime_args, runtime_options = {})
    super

    @model_file_name = @name
    @model_class_name = @class_name
    @controller_file_name = @plural_name
    @controller_class_name = @plural_name.capitalize
    
    @categories = args || []
  end
  
  def manifest
    record do |m|
      # Controller
      m.template "controller.rb", File.join("app/controllers", "#{controller_file_name}_controller.rb" )
      
      # Helper
      m.template "helper.rb", File.join("app/helpers", "#{controller_file_name}_helper.rb")
      
      # Model
      m.template "model.rb", File.join("app/models", "#{model_file_name}.rb")
            
      # Views
      m.directory "app/views/#{controller_file_name}"
      m.template "_category.html.erb", File.join("app/views", controller_file_name, "_category.html.erb")
      m.template "_node_form.html.erb", File.join("app/views", controller_file_name, "_node_form.html.erb")
      m.template "_select.html.erb", File.join("app/views", controller_file_name, "_#{model_file_name}_select.html.erb")
      
      m.file "spinner.gif", "public/images/tree-spinner.gif"
      
      # Migration
      m.migration_template 'migration.rb', 'db/migrate', :assigns => {
        :migration_name => "Create#{controller_class_name}"
      }, :migration_file_name => "create_#{controller_file_name}"
    end
  end
end