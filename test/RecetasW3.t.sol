// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/RecetasW3.sol";

contract RecetasW3Test is Test {
    RecetasW3 private recetas;
    string private constant HASH = "hash123";
    RecetasW3.Medicamento[] private medicamentos;

    function setUp() public {
        recetas = new RecetasW3();
        RecetasW3.Medicamento memory medicamento = RecetasW3.Medicamento({
            codigo: "COD123",
            cantidad: 10
        });
        medicamentos.push(medicamento);
    }

    function testEmitirRecetaCorrectamente() public {
        recetas.emitirReceta(HASH, medicamentos);
        RecetasW3.Receta memory rec = recetas.verificarReceta(HASH);
        assertEq(rec.hash, HASH);
        assertFalse(rec.dispensada); // Utiliza el campo booleano directamente
    }



    function testFalloAlEmitirRecetaRepetida() public {
        recetas.emitirReceta(HASH, medicamentos);
        vm.expectRevert(unicode"La receta ya ha sido emitida.");
        recetas.emitirReceta(HASH, medicamentos);
    }

    function testDispensarMedicamentoCorrectamente() public {
        recetas.emitirReceta(HASH, medicamentos);
        recetas.dispensarMedicamento(HASH, "DID123");
        RecetasW3.Receta memory rec = recetas.verificarReceta(HASH);
        assertTrue(rec.dispensada);
        assertEq(rec.DIDfarmacia, "DID123");
    }

    function testFalloAlDispensarMedicamentoNoEmitido() public {
        vm.expectRevert(unicode"La receta no existe.");
        recetas.dispensarMedicamento(HASH, "DID123");
    }
    function testFalloAlDispensarRecetaYaDispensada() public {
        recetas.emitirReceta(HASH, medicamentos);
        recetas.dispensarMedicamento(HASH, "DID123");
        vm.expectRevert(unicode"La receta ya fue dispensada.");
        recetas.dispensarMedicamento(HASH, "DID124");
    }
}
