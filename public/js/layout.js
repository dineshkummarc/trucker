(function ($) {
  // errors is an array of errors
  // render :json => {:errors => @item.errors.full_messages}
  function FormErrors(errors) {
    var error_count = errors.length;

    function errorUl() {
      var lis = '';
      errors.forEach(function(error) {
        lis += '<li>' + error + '</li>';
      });
      return '<ul>' + lis + '</ul>';
    }

    function errorHeading() {
      var error_str = error_count === 1 ? 'error' : 'errors';
      return '<h2>' + error_count + ' ' + error_str + ' prevented this form from being saved</h2>';
    }

    this.html = function() {
      var html = '';
      html += '<div class="errorExplanation" id="errorExplanation">';
      html += errorHeading();
      html += errorUl();
      html += '</div>';
      return html;
    };
  }

  $.fn.showErrors = function(errors) {
    return this.each(function() {
      $(this).removeErrors().prepend(new FormErrors(errors).html());
    });
  };

  $.fn.removeErrors = function() {
    return this.each(function() {
      $(this).find('.errorExplanation').remove();
    });
  };

  $.fn.enableSubmits = function() {
    return this.each(function() {
      $(this).find('input[type=submit]').enable();
    });
  };

  $.fn.disableSubmits = function() {
    return this.each(function() {
      $(this).find('input[type=submit]').enable(false);
    });
  };
})(jQuery);

var Layout = {
  get: function(url) {
    $.ajax({
      url      : url,
      dataType : 'json',
      success  : Layout.applyJSON
    });
  },

  destroy: function(url, data) {
    data = data || {};
    data._method = 'delete';
    
    $.ajax({
      url      : url,
      type     : 'post',
      dataType : 'json',
      data     : data,
      success  : Layout.applyJSON
    });
  },

  applyJSON: function(json) {
    for(key in json) {
      switch(key) {
        case 'html':
          for(selector in json[key]) {
            $(selector).html(json[key][selector]);
          }
          break;
        case 'append':
          for(selector in json[key]) {
            $(selector).append(json[key][selector]);
          }
          break;
        case 'remove':
          $(json[key].join(',')).remove();
          break;
      }
    }
  }
};

$('form').live('submit', function(event) {
  var $form = $(this);

  $form.disableSubmits().ajaxSubmit({
    dataType: 'json',
    success: function(json) {
      if (json.errors) {
        $form.trigger('form:error', [json]).showErrors(json.errors);
      } else {
        Layout.applyJSON(json);
        $form.trigger('form:success', [json]).removeErrors().resetForm();
      }
    },
    error: function(response, status, error) {
      $form.trigger('form:error', [response, status, error]);
    },
    complete: function() {
      $form.enableSubmits().trigger('form:complete');
    }
  });

  return false;
});

$('a.delete').live('click', function(event) {
  Layout.destroy($(this).attr('href'));
  return false;
});