'use strict';
const {
  Model
} = require('sequelize');
module.exports = (sequelize, DataTypes) => {
  class Katalog extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      Katalog.belongsTo(models.Kategori, {
        foreignKey: {
          name: 'kategoriId',
          allowNull: true // Letakkan di dalam objek foreignKey
        },
        as: 'kategori',
        onDelete: 'SET NULL',
        onUpdate: 'CASCADE'
      });
    }
  }
  Katalog.init({
    kategoriId:{
      type:DataTypes.INTEGER,
      allowNull:true,
      references: {
        model: 'Kategoris',
        key: 'id'
      }
    },
    merk: {
      type: DataTypes.ENUM('Toyota', 'Honda', 'Mitsubishi', 'Daihatsu', 'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru'),
      allowNull: false
    },
    nama_mobil: {
      type: DataTypes.STRING,
      allowNull: false
    },
    tahun_mobil:{
      type: DataTypes.INTEGER,
      allowNull: false
    },
    transmisi: {
      type: DataTypes.ENUM('manual', 'otomatis'),
      allowNull: false
    },
    bahan_bakar:{
      type: DataTypes.ENUM('bensin', 'diesel', 'listrik'),
      allowNull: false
    },
    warna_mobil:{
      type: DataTypes.STRING, 
      allowNull: false    
    },
    gambar:{
      type: DataTypes.TEXT,
      allowNull: false
    },
    kapasitas_penumpang:{
      type: DataTypes.INTEGER,
      allowNull: false
    },
    harga_mobil:{
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue:100000000
    },
    kapasitas_mesin:{
      type: DataTypes.INTEGER,
      allowNull: false
    },
    createdAt: {
      allowNull: false,
      type: DataTypes.DATE
    },
    updatedAt: {
      allowNull: false,
      type: DataTypes.DATE
    }
  }, {
    sequelize,
    modelName: 'Katalog',
  });
  return Katalog;
};