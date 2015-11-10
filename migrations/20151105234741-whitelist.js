'use strict';

module.exports = {
  up: function (queryInterface, Sequelize) {
    return queryInterface.createTable(
      'whitelists',
      {
        id: {
          type: Sequelize.INTEGER,
          primaryKey: true,
          autoIncrement: true
        },
        createdAt: {
          type: Sequelize.DATE
        },
        updatedAt: {
          type: Sequelize.DATE
        },
        name: Sequelize.STRING,
        domain: Sequelize.STRING,
        'groupId': Sequelize.INTEGER
      }
      );
  },

  down: function (queryInterface, Sequelize) {
    return queryInterface.dropTable('whitelists')
  }
};
