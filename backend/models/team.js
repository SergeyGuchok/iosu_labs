const sequelize = require('sequelize');
const db = require('../database/db')

const team = db.define('team', {
    id_team: {
      type: sequelize.STRING,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false
    },
    name: {
      type: sequelize.STRING,
    }
  },  {
    timestamps: false
  }
);

module.exports = team
