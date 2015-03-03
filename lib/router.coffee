Router.configure
  notFoundTemplate: 'notFound',
  layoutTemplate: 'layout'

Router.route '/',{name: 'page'}

# Router.route '/:_id', {name: 'userPage'}

# Router.onBeforeAction('dataNotFound', {only: 'postPage'});
