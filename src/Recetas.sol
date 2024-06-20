// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RecetasW3 {
    struct Medicamento {
        string codigo;
        uint cantidad;
    }

    struct Receta {
        string hash;
        string estado;
        string DIDfarmacia;
        Medicamento[] medicamentos;
    }

    mapping(string => Receta) public recetas;

    event RecetaEmitida(string hash);
    event RecetaDispensada(string hash, string DIDfarmacia);

    function emitirReceta(
        string memory _hash,
        Medicamento[] memory _medicamentos
    ) public {
        require(bytes(recetas[_hash].hash).length == 0, unicode"La receta ya ha sido emitida.");
        
        Receta storage receta = recetas[_hash];
        receta.hash = _hash;
        receta.estado = "emitida";
        receta.DIDfarmacia = "";

        for (uint i = 0; i < _medicamentos.length; i++) {
            receta.medicamentos.push(Medicamento({
                codigo: _medicamentos[i].codigo,
                cantidad: _medicamentos[i].cantidad
            }));
        }

        emit RecetaEmitida(_hash);
    }

    function dispensarMedicamento(string memory _hash, string memory _DIDfarmacia) public {
        Receta storage receta = recetas[_hash];
        require(keccak256(bytes(receta.estado)) == keccak256(bytes("emitida")), unicode"Receta no válida o ya dispensada.");
        
        receta.DIDfarmacia = _DIDfarmacia;
        receta.estado = "dispensada";

        emit RecetaDispensada(_hash, _DIDfarmacia);
    }

    function verificarReceta(string memory _hash) public view returns (Receta memory) {
        return recetas[_hash];
    }
}