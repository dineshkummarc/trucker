(function($) {
  
  var app = $.sammy(function() {
    this.use(Sammy.Template);
    
    this.get('#/', function(context) {
      var $container = $('#projects').html('Loading...');
      
      $.ajax({
        url       : '/projects.json',
        dataType  : 'json',
        success   : function(projects) {
          $container.html('');
          
          $.each(projects, function(i, project) {
            context.partial('templates/project.template', {project: project}, function(rendered) {
              $container.append(rendered);
            });
          });
        }
      });
    });
    
    this.post('#/projects', function(context) {
      var $form     = $('#create_project_form'),
          $projects = $('#projects');
      
      $form.ajaxSubmit({
        url       : $form.attr('action').replace('#', ''),
        dataType  : 'json',
        success   : function(json) {
          if (json.errors) {
            alert(json.errors);
          } else {
            context.partial('templates/project.template', {project:json}, function(rendered) {
              $projects.append(rendered);
            });
            
            $form.resetForm();
          }
        }
      });
      
      return false;
    });
  });
    
  $(function() {
    app.run('#/');
  });
  
})(jQuery);
