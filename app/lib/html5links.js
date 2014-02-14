// AMD/global registrations
(function (root, factory) {
    // Disable on Node.JS environment
    if (typeof window === 'undefined')
        return;

    // AMD. Register as an anonymous module.
    if (typeof define === 'function' && define.amd) {
        define(['gator'], function (gator) {
            return (factory(gator));
        });
    }  else if (typeof exports !== 'undefined') {
        factory(require('gator'), require('backbone'));
    }
    else {
        factory(root.Gator);
    }
}(this, function (Gator, Backbone) {
    Gator(document).on('click', 'a', function(e) {
        var href = this.getAttribute('href')
        var target = this.getAttribute('target')
        if(href && href !== '#' && !target) {
            e.preventDefault();
            Backbone.history.navigate(href, true);
        }
    })
}));
