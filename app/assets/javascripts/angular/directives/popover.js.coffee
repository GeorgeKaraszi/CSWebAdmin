@app = angular.module('formBuilder')

@app.directive 'popover', [($compile)->
  return {
    restrict: 'AE',
    template: '<span>{{label}}</span>',
    link: (scope, el, attrs)->
      scope.label = attrs.popoverLabel
      $(el).popover({
        trigger: 'hover',
        html: true,
        content: attrs.popoverHtml,
        placement: attrs.popoverPlacement
      })
  }
]