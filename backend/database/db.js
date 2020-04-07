const Sequelize = require('sequelize');

module.exports = new Sequelize('iosu', 'root', 'zed83rger', {
    dialect: 'mysql',
    host: 'localhost'
})