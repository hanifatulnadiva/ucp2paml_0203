const {Katalog}= require('../models');

exports.create_katalog = async (req, res) => {
    try{
        const {kategoriId, merk, nama_mobil, tipe_mobil, tahun_mobil, transmisi, bahan_bakar, warna_mobil, gambar, kapasitas_penumpang, harga_mobil, kapasitas_mesin} = req.body;
        const kategori = await kategori.findById(kategoriId);
        if(!kategori) return res.status(404).json({message:"Kategori tidak ditemukan"});

        const newKatalog = await Katalog.create({
            kategoriId,
            merk,
            nama_mobil,
            tipe_mobil,
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
            include:[{ model: kategori,
                as:'kategoris',
                atributes:['jenis_mobil']
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
        const katalog = await Katalog.findById({
            where:{ id_katalog:id},
            include:[{model:UserActivation, asa:'user'}]
        });
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
        const katalog = await Katalog.findById({
            where:{id_katalog:id}
        });
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
    const {id} = req.params;
    try{
        const deleted = await Katalog.destroy({
            where:{id_katalog:id}
        });
        if(deleted) res.status(200).json({message:"Katalog berhasil dihapus!"});
        else res.status(404).json({message:"Katalog tidak ditemukan!"});
    }catch(error){
        res.status(500).json({message:"Gagal menghapus: " +error.message});
    }
}

