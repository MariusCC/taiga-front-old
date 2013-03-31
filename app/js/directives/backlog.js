'use strict';

angular.module('greenmine.directives.backlog', []).
    directive('gmPointsPopover', ["$parse", function($parse) {
        return function(scope, elm, attrs) {
            var fn = $parse(attrs.gmPointsPopover);
            var element = angular.element(elm);

            element.on("click", function(event) {
                event.preventDefault();

                element.popover({
                    content: $("#points-popover").html(),
                    html:true,
                    trigger: "manual"
                });

                element.popover("show");
            });

            element.parent().on("click", ".popover-content a.btn", function(event) {
                event.preventDefault();

                var target = angular.element(event.currentTarget);
                var pointId = target.data('id');

                scope.$apply(function() {
                    fn(scope, {"points": pointId});
                });

                element.popover('hide');
            });
        };
    }]).
    directive("gmUspreviewPopover", ['$parse', '$compile', function($parse, $compile) {
        return function(scope, elm, attrs) {
            var element = angular.element(elm);
            var isOpened = false

            element.on("click", function(event) {
                event.preventDefault();

                if (isOpened) {
                    isOpened = false;
                    element.popover("hide");
                } else {
                    var template = _.template($("#us-preview-popover").html());
                    isOpened = true;

                    element.popover({
                        content: template({us: scope.us}),
                        html:true,
                        trigger: "manual"
                    });

                    element.popover("show");
                }
            });
        };
    }]);
