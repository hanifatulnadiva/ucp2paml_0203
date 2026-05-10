const{Kategori}= require('../models');

exports.create_kategori = async(req, res)=>{
    try{
        const{jenis_mobil}= req.body;
        if(!jenis_mobil){
            return res.status(400).json({message:"Jenis Mobil harus diisi"});
        };
        const newKategori = await Kategori.create({jenis_mobil});
        res.status(201).json({
            message:"Kategori berhasil dibuat",
            data: newKategori
        });
    }
    catch(error){
        res.status(500).json({message:"Terjadi kesalahan pada server", error:error.message});
    }
}

exports.update_kategori= async(req, res)=>{
    const kategori= await Kategori.findById(req.params.id);
    if(!kategori){
        return res.status(404).json({ message:"Kategori tidak ditemukan"});
    }

    await kategori.update(req.body);
    res.json({
        status:true,
        message:"Kategori berhasildi perbarui",
        data: kategori
    });
};

exports.delete_kategori= async(req, res)=>{
    const kategori= await Kategori.findById(req.params.id);
    if(!kategori){
        return res.status(404).json({ message:"Kategori tidak ditemukan"});
    }
    await kategori.destroy();
    res.json({
        status:true,
        message:"Kategori berhasil dihapus"
    });
};

exports.get_all_kategori= async(req, res)=>{
    const kategori= await Kategori.findAll();
    res.json({
        status:true,
        message:"Berhasil mendapatkan semua kategori",
        data: kategori
    });
}