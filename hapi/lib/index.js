var Hapi = require('hapi');
var Hoek = require('hoek');
var Joi = require('joi');

var Hello = require('./hello');

var internals = {};

internals.defaults = {

};

exports.register = function (plugin, options, next) {

    var settings = Hoek.applyToDefaults(internals.defaults, options);
        
    plugin.route([
        { method: 'GET', path: '/hello', config: { handler: Hello.get } }
    ]);

    next();
};
