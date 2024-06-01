// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContratoDeRecetas {
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
        recetas[_hash] = Receta({
            fechaReceta: _fechaReceta,
            fechaVencimiento: _fechaVencimiento,
            didMedico: _didMedico,
            didPaciente: _didPaciente,
            financiador: _financiador,
            drogas: _drogas,
            indicaciones: _indicaciones,
            estado: "emitida",
            hash: _hash,
            farmacia: address(0),
            medicamentos: _medicamentos
        });

        emit RecetaEmitida(_hash, _didMedico, _didPaciente);
    }

    function dispensarMedicamento(string memory _hash, address _farmacia) public {
        require(!recetas[_hash].dispensada, "Receta ya dispensada.");
        recetas[_hash].farmacia = _farmacia;
        recetas[_hash].estado = "dispensada";

        emit RecetaDispensada(_hash, _farmacia);
    }

    function verificarReceta(string memory _hash) public view returns (Receta memory) {
        require(keccak256(abi.encodePacked(recetas[_hash].estado)) == keccak256(abi.encodePacked("emitida")), "Receta no válida o ya dispensada.");
        return recetas[_hash];
    }
}
