// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RecetasW3 {
    struct Medicamento {
        string codigo;
        uint cantidad;
    }

    struct Receta {
        uint256 fechaReceta;
        uint256 fechaVencimiento;
        string didMedico;
        string didPaciente;
        string financiador;
        string drogas;
        string indicaciones;
        string estado;
        string hash;
        address farmacia;
        Medicamento[] medicamentos;
    }

    mapping(string => Receta) public recetas;

    event RecetaEmitida(string hash, string didMedico, string didPaciente);
    event RecetaDispensada(string hash, address farmacia);

    function emitirReceta(
        string memory _hash,
        uint256 _fechaReceta,
        uint256 _fechaVencimiento,
        string memory _didMedico,
        string memory _didPaciente,
        string memory _financiador,
        string memory _drogas,
        string memory _indicaciones,
        Medicamento[] memory _medicamentos
    ) public {
        require(_fechaVencimiento > _fechaReceta, unicode"La fecha de vencimiento debe ser posterior a la fecha de receta.");
        require(recetas[_hash].fechaReceta == 0, unicode"La receta ya ha sido emitida.");
        Receta storage receta = recetas[_hash];
        receta.fechaReceta = _fechaReceta;
        receta.fechaVencimiento = _fechaVencimiento;
        receta.didMedico = _didMedico;
        receta.didPaciente = _didPaciente;
        receta.financiador = _financiador;
        receta.drogas = _drogas;
        receta.indicaciones = _indicaciones;
        receta.estado = "emitida";
        receta.hash = _hash;
        receta.farmacia = address(0);
        
        // Manejar la copia de los medicamentos
        for (uint i = 0; i < _medicamentos.length; i++) {
            receta.medicamentos.push(Medicamento({
                codigo: _medicamentos[i].codigo,
                cantidad: _medicamentos[i].cantidad
            }));
        }

        emit RecetaEmitida(_hash, _didMedico, _didPaciente);
    }

    function dispensarMedicamento(string memory _hash, address _farmacia) public {
        Receta storage receta = recetas[_hash];
        require(keccak256(bytes(receta.estado)) == keccak256(bytes("emitida")), unicode"Receta no válida o ya dispensada.");
        require(receta.fechaVencimiento >= block.timestamp, unicode"La receta ha expirado.");
        receta.farmacia = _farmacia;
        receta.estado = "dispensada";

        emit RecetaDispensada(_hash, _farmacia);
    }

    function verificarReceta(string memory _hash) public view returns (Receta memory) {
        return recetas[_hash];
    }
}
