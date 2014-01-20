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
    var optionalParamOpen = /\(/g;
    var optionalParamClose = /\)/g;
    var namedParam = /(\(\?)?:\w+/g;
    var splatParam = /\*\w+/g;
    var escapeRegExp = /[\-{}\[\]+?.,\\\^$|#\s]/g;

    Backbone.Router = Backbone.Router.extend({
        // Update interface globally
        update: function () {
        },

        // Manually bind a single named route to a callback. For example:
        //
        //     this.route('search/:query/p:num', 'search', function(query, num) {
        //       ...
        //     });
        //
        route: function (route, name, callback) {
            // RegEx route not supported. Create regex from string
            if (_.isRegExp(route))
                throw new Error('RegEx route not supported!')
            route = this._routeToRegExp(route);

            // Create callback function
            if (_.isFunction(name)) {
                callback = name;
                name = '';
            }
            if (!callback) callback = this[name];

            // Bind to history
            var router = this;
            Backbone.history.route(route.regex, function (fragment) {
                var args = router._extractParameters(route.regex, fragment);
                router._lastParams = _.object(_.map(args, function (v, i) {
                    return [route.names[i], v]
                }));
                router._lastName = name

                // Trigger force enabled. Just set last name and props (above)
                // and exit without callback calls
                if (router._not_trigger) {
                    router._not_trigger = false;
                    return;
                }

                // Invoke callbacks and triggers
                (callback && callback.apply(router, args)) || router.update();
                router.trigger.apply(router, ['route:' + name].concat(args));
                router.trigger('route', name, args);
                Backbone.history.trigger('route', router, name, args);
            });
            return this;
        },

        // Return last route params object
        getParams: function () {
            return this._lastParams
        },

        // Return last route name string
        getRouteName: function () {
            return this._lastName
        },

        // Simple proxy to `Backbone.history` to save a fragment into the history.
        // UPDATED: set last name and last props
        navigate: function (fragment, options) {
            // Force enable trigger and set disabling trigger flag
            if (!options || !options.trigger) {
                this._not_trigger = true;
                options = options ? _.assign(options, {trigger: true}) : {trigger: true};
            }

            // Delegate to history
            Backbone.history.navigate(fragment, options);
            return this;
        },

        // Convert a route string into a regular expression, suitable for matching
        // against the current location hash.
        _routeToRegExp: function (route) {
            var names = []
            route = route.replace(escapeRegExp, '\\$&')
                .replace(optionalParamOpen, '(?:')
                .replace(optionalParamClose, ')?')
                .replace(namedParam, function (match, optional) {
                    names.push(match.substr(1))
                    return optional ? match : '([^\/]+)';
                })
                .replace(splatParam, '(.*?)')

            return {
                regex: new RegExp('^' + route + '$'),
                names: names
            };
        },

        // Given a route, and a URL fragment that it matches, return the array of
        // extracted decoded parameters. Empty or unmatched parameters will be
        // treated as `null` to normalize cross-browser behavior.
        _extractParameters: function (route, fragment) {
            var params = route.exec(fragment).slice(1);
            return _.map(params, function (param) {
                return param ? decodeURIComponent(param) : null;
            });
        }
    });

    return Backbone.Router;
}))
;
