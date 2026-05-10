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
      Katalog.belongsTo(models.Kategori,{
        foreignKey:'kategoriId',
        as :'kategori'
      })
    }
  }
  Katalog.init({
    kategoriId:{
      type:DataTypes.INTEGER,
      allowNull:false,
    },
    merk: {
      type: Sequelize.ENUM('Toyota', 'Honda', 'Mitsubishi', 'Daihatsu', 'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru'),
      allowNull: false
    },
    nama_mobil: {
      type: Sequelize.STRING,
      allowNull: false
    },
    tipe_mobil:{
      type: Sequelize.ENUM('MPV','SUV', 'Sedan', 'Hatchback', 'Sport', 'Truck Pickup', 'Minivan', 'Coupe'),
      allowNull: false
    },
    tahun_mobil:{
      type: Sequelize.INTEGER,
      allowNull: false
    },
    transmisi: {
      type: Sequelize.ENUM('manual', 'otomatis'),
      allowNull: false
    },
    bahan_bakar:{
      type: Sequelize.ENUM('bensin', 'diesel', 'listrik'),
      allowNull: false
    },
    warna_mobil:{
      type: Sequelize.STRING, 
      allowNull: false    
    },
    gambar:{
      type: Sequelize.TEXT,
      allowNull: false
    },
    kapasitas_penumpang:{
      type: Sequelize.INTEGER,
      allowNull: false
    },
    harga_mobil:{
      type: Sequelize.INTEGER,
      allowNull: false,
      defaultValue:100000000
    },
    kapasitas_mesin:{
      type: Sequelize.INTEGER,
      allowNull: false
    },
    createdAt: {
      allowNull: false,
      type: Sequelize.DATE
    },
    updatedAt: {
      allowNull: false,
      type: Sequelize.DATE
    }
  }, {
    sequelize,
    modelName: 'Katalog',
  });
  return Katalog;
};