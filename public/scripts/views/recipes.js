// Generated by CoffeeScript 1.3.1
(function() {

  $(function() {
    window.FilterView = Backbone.View.extend({
      id: "FilterView",
      events: {
        'keyup input#searchForm': 'keyLog'
      },
      initialize: function() {
        return _.bindAll(this, 'render', 'getData');
      },
      keyLog: function() {
        if (typeof this.keyTimeout !== "undefined") {
          window.clearTimeout(this.keyTimeout);
        }
        return this.keyTimeout = window.setTimeout(this.getData, 500);
      },
      getData: function() {
        this.collection.query.searchstring = $('input', this.el).val();
        return this.collection.fetch();
      },
      render: function() {
        $(this.el).html(Mustache.to_html($("#FilterView-template").html(), null));
        return this;
      }
    });
    window.SearchView = Backbone.View.extend({
      template: Utility.create_template("#SearchView-template"),
      initialize: function() {
        return this.recipeResultView = new IngrResultView({
          collection: this.collection
        });
      },
      render: function() {
        console.log("search view render");
        $(this.el).append(this.recipeResultView.render().el);
        this.collection.fetch();
        return this;
      }
    });
    window.IngrResultView = Backbone.View.extend({
      tagName: "table",
      className: "table table-striped table-bordered",
      id: "IngrResults",
      initialize: function() {
        _.bindAll(this, 'render');
        return this.collection.bind("reset", this.render);
      },
      render: function() {
        $(this.el).html("");
        this.collection.each(function(item) {
          var ingr;
          console.log("iterate");
          ingr = new IngrListElementView({
            model: item
          });
          return $("table#IngrResults").append(ingr.render().el);
        });
        return this;
      }
    });
    window.IngrListElementView = Backbone.View.extend({
      template: Utility.create_template("#IngredientListViewElement-template"),
      tagName: "tr",
      events: {
        'click': 'showDetails'
      },
      initialize: function() {
        return _.bindAll(this, 'render', 'showDetails');
      },
      render: function() {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
      },
      showDetails: function() {
        $('table#IngrResults tr').removeClass("active");
        $(this.el).addClass("active");
        this.recipeDetailView = new IngrDetailView({
          model: this.model
        });
        return $('#container').html(this.recipeDetailView.render().el);
      }
    });
    return window.IngrDetailView = Backbone.View.extend({
      template: Utility.create_template("#IngredientDetailView-template"),
      initialize: function() {
        return _.bindAll(this, 'render');
      },
      render: function() {
        $(this.el).html(this.template(this.model.toJSON()));
        return this;
      }
    });
  });

}).call(this);
