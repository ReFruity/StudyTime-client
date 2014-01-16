// This backbone.route modification
// just adds catching route part names
// and push to callback args {partOneName: value1, partTwoName: value2}
// when invoking callback of route

(function (factory) {
    if (typeof define === 'function' && define.amd) {
        // Register as an AMD module if available...
        define(['underscore', 'backbone'], factory);
    } else {
        // Browser globals for the unenlightened...
        factory(_, Backbone);
    }
}(function (_, Backbone) {
    // Cached regular expressions for matching named param parts and splatted
    // parts of route strings.
    var optionalParam = /\((.*?)\)/g;
    var namedParam = /(\(\?)?:\w+/g;
    var splatParam = /\*\w+/g;
    var escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;

    Backbone.Router = Backbone.Router.extend({
        // Save route part names there
        _routeParts: {},

        // Manually bind a single named route to a callback. For example:
        //
        //     this.route('search/:query/p:num', 'search', function(query, num) {
        //       ...
        //     });
        //
        route: function (_route, name, callback) {
            var route = _route;
            if (!_.isRegExp(route)) route = this._routeToRegExp(route);
            if (_.isFunction(name)) {
                callback = name;
                name = '';
            }
            if (!callback) callback = this[name];
            var router = this;
            Backbone.history.route(route, function (fragment) {
                var args = router._extractParameters(route, fragment);
                if(router._routeParts[_route]) {
                    args.push(_.object(_.map(args, function(v, i) {
                        return [router._routeParts[_route][i], v]
                    })));
                }

                callback && callback.apply(router, args);
                router.trigger.apply(router, ['route:' + name].concat(args));
                router.trigger('route', name, args);
                Backbone.history.trigger('route', router, name, args);
            });
            return this;
        },

        // Convert a route string into a regular expression, suitable for matching
        // against the current location hash.
        _routeToRegExp: function (route) {
            var self = this;
            self._routeParts[route] = [];
            route = route.replace(escapeRegExp, '\\$&')
                .replace(optionalParam, '(?:$1)?')
                .replace(namedParam, function (match, optional) {
                    self._routeParts[route].push(match.substr(1))
                    return optional ? match : '([^\/]+)';
                })
                .replace(splatParam, '(.*?)');

            return new RegExp('^' + route + '$');
        }

    });

    return Backbone.Router;
}))
;
