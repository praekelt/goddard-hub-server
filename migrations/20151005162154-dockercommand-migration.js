'use strict';

module.exports = {
  up: function (queryInterface, Sequelize) {
    return queryInterface.addColumn(
      'apps',
      'docker_command',
      Sequelize.STRING
    );
  },

  down: function (queryInterface, Sequelize) {
    return queryInterface.removeColumn('apps', 'docker_command')
  }
};
