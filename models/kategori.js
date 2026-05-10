'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Kategori extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
    }
  }
  Kategori.init({
    jenis_mobil: DataTypes.STRING,
    allowNull: false,
      unique: true,
      validate: {
        isJenisMobil: true 
      }
  }, {
    sequelize,
    modelName: 'Kategori',
  });
  return Kategori;
};