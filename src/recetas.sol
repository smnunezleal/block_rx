// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ContratoDeRecetas {
    struct Receta {
        string hash;
        string medicamento;
        string estado;
        address doctor;
        string hashDIDPaciente;
        uint256 fechaCreacionDID;
        bool dispensada;
    }

    mapping(string => Receta) public recetas;

    event RecetaEmitida(string hash, address doctor, string hashDIDPaciente, uint256 fechaCreacionDID);
    event RecetaDispensada(string hash, address farmacia);

    function emitirReceta(
        string memory _hash,
        string memory _medicamento,
        address _doctor,
        string memory _hashDIDPaciente,
        uint256 _fechaCreacionDID
    ) public {
        recetas[_hash] = Receta({
            hash: _hash,
            medicamento: _medicamento,
            estado: "emitida",
            doctor: _doctor,
            hashDIDPaciente: _hashDIDPaciente,
            fechaCreacionDID: _fechaCreacionDID,
            dispensada: false
        });

        emit RecetaEmitida(_hash, _doctor, _hashDIDPaciente, _fechaCreacionDID);
    }

    function dispensarMedicamento(string memory _hash, address _farmacia) public {
        require(!recetas[_hash].dispensada, "Receta ya dispensada.");
        recetas[_hash].dispensada = true;
        recetas[_hash].estado = "dispensada";

        emit RecetaDispensada(_hash, _farmacia);
    }

    function verificarReceta(string memory _hash) public view returns (Receta memory) {
        require(!recetas[_hash].dispensada, "Receta ya dispensada.");
        return recetas[_hash];
    }
}
