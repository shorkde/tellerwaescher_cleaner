// Generated by CoffeeScript 1.3.1
(function() {

  $(function() {
    var Utility;
    Utility = function() {
      var create_template, format_steps;
      create_template = function(id) {
        var cache;
        cache = $(id).html();
        return function(object) {
          return Mustache.to_html(cache, object);
        };
      };
      format_steps = function(rawStepData) {
        var counter, length, maxlength, step, stepcount, stepglobalcount, steps, substepcount;
        counter = 0;
        steps = new Array();
        length = 0;
        stepcount = 0;
        stepglobalcount = 1;
        maxlength = 500;
        step = new Object();
        step.items = new Array();
        substepcount = 0;
        _.each(rawStepData.steps, function(rootNum, key) {
          return _.each(rootNum, function(num, key) {
            if (length + num.length < maxlength && typeof rootNum[key + 1] !== "undefined") {
              step.items[substepcount++] = {
                count: stepglobalcount++,
                text: num
              };
              return length = length + num.length;
            } else {
              steps[stepcount++] = step;
              step = new Object();
              step.items = new Array();
              substepcount = 0;
              step.items[substepcount++] = {
                count: stepglobalcount++,
                text: num
              };
              length = num.length;
              if (typeof rootNum[key + 1] === "undefined") {
                return _.last(steps).items[_.last(steps).items.length + 1] = {
                  count: stepglobalcount - 1,
                  text: num
                };
              }
            }
          });
        });
        return steps;
      };
      return {
        create_template: create_template,
        format_steps: format_steps
      };
    };
    return window.Utility = new Utility();
  });

}).call(this);
