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
    Backbone.Model = Backbone.Model.extend({
        fetchThis: function (options) {
            this.fetch(options)
            return this;
        }
    });

    return Backbone.Model;
}));