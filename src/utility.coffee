$ ->
  Utility = -> (
    create_template = (id) ->
      cache = $(id).html()
      (object) ->
        Mustache.to_html cache, object

    format_steps = (rawStepData) ->
      counter = 0;

      steps = new Array()
      length = 0
      stepcount = 0
      stepglobalcount = 1
      maxlength = 500
      step = new Object()
      step.items = new Array()
      substepcount = 0

      _.each(rawStepData.steps, (rootNum,key) ->
        _.each(rootNum, (num,key) ->
          if length + num.length < maxlength && typeof rootNum[key+1] != "undefined"

            step.items[substepcount++] = { count: stepglobalcount++, text: num }
            length = length + num.length
          else
            #write data
            steps[stepcount++] = step

            #create new step data
            step = new Object()
            step.items = new Array()
            substepcount = 0
            step.items[substepcount++] = { count: stepglobalcount++, text: num }
            length = num.length

            if typeof rootNum[key+1] == "undefined"
              _.last(steps).items[_.last(steps).items.length + 1] = { count: stepglobalcount-1, text: num }
        );
      );

      return steps

    create_template: create_template
    format_steps: format_steps
  )
  window.Utility = new Utility();