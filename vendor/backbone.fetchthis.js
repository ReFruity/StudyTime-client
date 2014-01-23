// This backbone.model modification adds
// useful .fetchThis() method, returning 'this'
// instead jqXHR

(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // Register as an AMD module if available...
        define(['underscore', 'backbone'], factory);
    } else {
        // Browser globals for the unenlightened...
        factory(_, Backbone);
    }
}(function (_, Backbone) {
    var old_model = Backbone.Model
    Backbone.Model = Backbone.Model.extend({
        fetchThis: function (options) {
            this.fetchActive = true;
            if (!options) options = {};
            var success = options.success;
            options.success = function (model, resp, options) {
                model.fetchActive = false;
                if (success) success(model, resp, options);
            };

            this.fetch(options);
            return this;
        },

        fetch: function (options) {
            var fetch = old_model.prototype.fetch.apply(this, arguments);
            var model = this;
            if (fetch.fail)
                fetch.fail(function() {
                    console.log(model);
                    model.fetchActive = false;
                    model.trigger('fetchError');
                });
        }
    });

    return Backbone.Model;
}));