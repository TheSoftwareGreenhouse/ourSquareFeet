
  http = require('http');

  exports.getResponse = function(path, nextStep) {
    var client, request;
    client = http.createClient('8080');
    request = client.request(path);
    request.end();
    request.on('response', function(res) {
      var body;
      body = "";
      res.on('data', function(chunk) {
        body += chunk;
      });
      res.on('end', function() {
        nextStep(null, body);
      });
    });
  };
