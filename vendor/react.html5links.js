// AMD/global registrations
(function (root, factory) {
    // Disable on Node.JS environment
    if (typeof window === 'undefined')
        return;

    // AMD. Register as an anonymous module.
    if (typeof define === 'function' && define.amd) {
        define(['react'], function (react) {
            return (factory(react));
        });
    } else {
        factory(root.React);
    }
}(this, function (react) {
    var aa = react.DOM.a
    react.DOM.a = React.createClass({
        render: function () {
            var href, onClick, _ref;
            _ref = this.props, onClick = _ref.onClick, href = _ref.href;
            return this.transferPropsTo(aa({
                onClick: function (e) {
                    e.preventDefault();
                    if (href && href !== "#") {
                        Backbone.history.navigate(href, true);
                    }
                    if (onClick) {
                        return onClick(e);
                    }
                }
            }, this.props.children));
        }
    });
}));
