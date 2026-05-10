const {Kategori, Katalog}= require('../models');

exports.create_katalog = async (req, res) => {
    try{
        const {kategoriId, merk, nama_mobil, tahun_mobil, transmisi, bahan_bakar, warna_mobil, gambar, kapasitas_penumpang, harga_mobil, kapasitas_mesin} = req.body;
        const kategori = await Kategori.findByPk(kategoriId);
        if(!kategori) return res.status(404).json({message:"Kategori tidak ditemukan"});

        const newKatalog = await Katalog.create({
            kategoriId,
            merk,
            nama_mobil,
            tahun_mobil,
            transmisi,
            bahan_bakar,
            warna_mobil,
            gambar,
            kapasitas_penumpang,
            harga_mobil,
            kapasitas_mesin
        });
        res.status(201).json({
            message:"Katalog berhasil dibuat",
            data: newKatalog
        });
    }catch(error){
        res.status(500).json({message:"Terjadi kesalahan pada server", error:error.message});
    }
};

exports.get_all_katalog = async (req, res) => {
    try{
        const katalogs = await Katalog.findAll({
            include:[{ 
                model: Kategori,
                as:'kategori',
                attributes:['jenis_mobil']
            }],
            order:[['createdAt','DESC']]
        });
        res.status(200).json({
            status:true,
            message:"Berhasil mendapatkan semua katalog",
            data:katalogs
        });
    }catch(error){
        res.status(500).json({message:"Terjadi kesalahan pada server", error:error.message});
    }
};

exports.get_katalog_by_id = async (req, res) => {
    const {id}= req.params;
    try{    
        const katalog = await Katalog.findByPk(id)
        if(!katalog) return res.status(404).json({message:"Katalog tidak ditemukan"});
        res.status(200).json({
            status:true,
            message:"Berhasil mendapatkan katalog",
            data:katalog
        })
    }catch(error){
        res.status(500).json({message:error.message});
    }
}
exports.update_katalog = async (req, res) => {
    const {id} = req.params;
    try{
        const katalog = await Katalog.findByPk(id);
        if(!katalog) return res.status(404).json({message:"Katalog tidak ditemukan"});
        await katalog.update(req.body);
        res.status(200).json({
            status:true,
            message:"Katalog berhasil diperbarui",
            data:katalog
        })
    }catch(error){
        res.status(500).json({message:error.message});
    }
};

exports.delete_katalog = async (req, res) => {
    try{
        const katalog = await Katalog.findByPk(req.params.id);
        if(!katalog) return res.status(404).json({message:"Katalog tidak ditemukan"});
        await katalog.destroy();
        res.status(200).json({message:"Katalog berhasil dihapus!"});
    }catch(error){
        res.status(500).json({message:"Gagal menghapus: " +error.message});
    }
}

