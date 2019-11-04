'use strict';
const todoList = require('../controllers/Controller');
 
module.exports = function(app) {
 
  //GET route for version
  app.route('/api/Version')
  	.get(todoList.list_version);
  
  //GET route for sizes
  app.route('/api/sizes')
    .get(todoList.sizes);

  //GET for the running the pseudo instance
  app.route('/api/pseudo')
    .get(todoList.psuedo);

  //POST for the setting own entropy
  app.route('/api/setentropy')
    .post(todoList.setentropy);

  //GET for getting entropy
  app.route('/api/entropy')
    .get(todoList.entropy);

  //GET for getting pool
  app.route('/api/pool')
    .get(todoList.getPool);

  //GET for getting attractors
  app.route('/api/attractors')
    .get(todoList.attractors);

};

  