const {Katalog}= require('../models');



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
