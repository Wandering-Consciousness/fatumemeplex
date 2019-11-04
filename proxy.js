// The basic Azure Web App Service we're using only exposes http and https ports (80 and 443).
// And we have two projects:
// Nick Falcoln's REST API server as a JSON wrapper to the Newton lib (running on 3000)
// The pm project that renders the word2vec-graph produced from /r/randonauts.
//
// Referenced:  https://itnext.io/hosting-multiple-apps-on-the-same-server-implement-a-reverse-proxy-with-node-a4e213497345

// Dependencies
const express = require('express');
const proxy = require('http-proxy-middleware');

// Config
const { routes } = require('./proxy_routes.json');

const app = express();

for (route of routes) {
    app.use(route.route,
        proxy({
            target: route.address,
            pathRewrite: (path, req) => {
                if (path.includes("/anu/") || path.includes("/api/")) // TODO: probably a better way to do this
                    return path.split('/').slice(2).join('/');
                return path;
            }
        })
    );
}

app.listen(8080, () => {
    console.log('Proxy listening on port 8080');
});