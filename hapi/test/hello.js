var Lab = require('lab');
var Hapi = require('hapi');

var internals = {};

var expect = Lab.expect;
var before = Lab.before;
var after = Lab.after;
var describe = Lab.experiment;
var it = Lab.test;

internals.prepareServer = function (callback) {
    var server = new Hapi.Server();
    server.pack.require('../', function (err) {

        expect(err).to.not.exist;
        callback(server);
    });
};
    
describe('hello', function () {

    it('GET /hello', function (done) {
        internals.prepareServer(function (server) {
            server.inject({ method: 'GET', url: '/hello'}, function (response) {

                expect(response.statusCode).to.equal(200);
                expect(response.payload).to.exist;
                done();
            });
        });
    });
});
