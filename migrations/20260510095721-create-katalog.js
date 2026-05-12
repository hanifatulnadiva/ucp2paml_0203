'use strict';
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable('Katalogs', {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER
      },
      merk: {
        type: Sequelize.ENUM('Toyota', 'Honda', 'Mitsubishi', 'Daihatsu', 'Suzuki', 'Nissan', 'Mazda', 'Isuzu', 'Subaru'),
        allowNull: false
      },
      nama_mobil: {
        type: Sequelize.STRING,
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
        allowNull: false
      },
      kapasitas_mesin:{
        type: Sequelize.INTEGER,
        allowNull: false
      },
      kategoriId:{
        type:Sequelize.INTEGER,
        allowNull:true

      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE
      }
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable('Katalogs');
  }
};