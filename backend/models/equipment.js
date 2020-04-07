const sequelize = require('sequelize');
const db = require('../database/db')

const equipment = db.define('equipment', {
    id_equipment: {
      type: sequelize.STRING,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false
    },
    capacity: {
      type: sequelize.STRING
    },
    life_time: {
      type: sequelize.STRING
    },
    provision_date: {
      type: sequelize.STRING
    },
    type: {
      type: sequelize.STRING
    },
    work_time: {
      type: sequelize.STRING
    }
  },  {
    timestamps: false
  }
);

module.exports = equipment
