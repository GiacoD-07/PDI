<?php
function sumarRecursos(int $a, int $b): int {
   
return $a + $b;
}
echo sumarRecursos(2,3) . "\n";
// PROPÓSITO: Devuelve la cantidad total de recursos al combinar dos líneas de producción.
// EJEMPLO: sumarRecursos(2,3) = 5

function tieneMasRecursos(int $a, int $b): bool {
  if ($a > $b) {
    return true;
  }
  return false;
}

echo tieneMasRecursos(2,6) ? "true" : "false" . "\n";
echo tieneMasRecursos(6,2) ? "true" : "false" . "\n";
// PROPÓSITO: Indica si la línea de producción $a tiene más recursos que la línea de producción $b.
// EJEMPLO: tieneMasRecursos(2,6) = false

function lineaMayor(int $a, int $b): int {
    return $a > $b ? $a : $b;
}
echo lineaMayor(10,6) . "\n";
echo lineaMayor(6,10) . "\n";
// PROPÓSITO: Devuelve la línea de producción con mayor cantidad de recursos.
// EJEMPLO: lineaMayor(10,6) = 10
function existeLineaConRecursos(array $lineasDeProduccion, int $cantidad): bool {
    foreach ($lineasDeProduccion as $linea) {
        if ($linea === $cantidad) {
            return true;
        }
  }
    return false;
}
echo existeLineaConRecursos([10,6,9], 6) ? "true" : "false" . "\n";
echo existeLineaConRecursos([10,6,9], 5) ? "true" : "false" . "\n";
// PROPÓSITO: Indica si existe una línea de producción con exactamente esa
// cantidad de recursos.
// PRECONDICIÓN: $lineasDeProduccion no es vacía
// EJEMPLO: existeLineaConRecursos([10,6,9], 6) = true

function lineaMaxima(array $lineasDeProduccion): int {
    $max = $lineasDeProduccion[0];
    foreach ($lineasDeProduccion as $linea) {
        if ($linea > $max) {
            $max = $linea;
        }
    }
    return $max;
}
echo lineaMaxima([10,6,9,-9,100,88]) . "\n";
// PROPÓSITO: Devuelve la línea de producción con la mayor cantidad de recursos dentro de una lista.
// PRECONDICIÓN: $lineasDeProduccion no es vacía
// EJEMPLO: lineaMaxima([10,6,9,-9,100,88]) = 100
// RESTRICCIONES:
// * Debes reutilizar funciones previamente definidas

function totalDeRecursos(array $lineasDeProduccion): int {
    $total = 0;
    foreach ($lineasDeProduccion as $linea) {
        $total = sumarRecursos($total, $linea);
    }
    return $total;
}
echo totalDeRecursos([1,2,3,4]) . "\n";
// PROPÓSITO: Devuelve la cantidad total de recursos disponibles en todas las líneas de producción.
// EJEMPLO: totalDeRecursos([1,2,3,4]) = 10

function produccionEnParalelo(int $cantidad, int $lineasDeProduccion): int {
    $total = 0;
    for ($i = 0; $i < $lineasDeProduccion; $i++) {
        $total = sumarRecursos($total, $cantidad);
    }
    return $total;
}
echo produccionEnParalelo(2,3) . "\n";
echo produccionEnParalelo(2,0) . "\n";
// PROPÓSITO: Devuelve la cantidad de recursos que se generan al tener varias
// líneas de producción generando la misma cantidad de recursos en paralelo.
// (Multiplicación)
// EJEMPLO:
// * produccionEnParalelo(2,3) = 6
// * produccionEnParalelo(2,0) = 0
// RESTRICCIONES:
// * No se pueden utilizar los operadores * y +
// * Debes usar alguna estructura de repetición
// * Debes reutilizar una función previamente definida

function produccionReplicada(int $base, int $nivel): int  {
    $total = 1;
    for ($i = 0; $i < $nivel; $i++) {
        $total = produccionEnParalelo($total, $base);
    }
    return $total;
}
echo produccionReplicada(2,3) . "\n"; 
echo produccionReplicada(2,0) . "\n";
// PROPÓSITO: Devuelve la producción total de recursos al aplicar múltiples
// niveles sobre una producción base, donde en cada nivel la producción acumulada
// se replica en paralelo tantas veces como indica la base.
// (Potenciación)
// EJEMPLO:
// * produccionReplicada(2,3) = 8
// * produccionReplicada(2,0) = 1
// RESTRICCIONES:
// * No se pueden utilizar los operadores *, + y **
// * No se puede usar la función pow
// * Debes usar alguna estructura de repetición
// * Debes reutilizar funciones previamente definidas
function lineasEnCrecimiento(array $lineasDeProduccion): array {
    $crecimiento = [];
    $crecimiento[] = $lineasDeProduccion[0];
    for ($i = 1; $i < count($lineasDeProduccion); $i++) {
        if (tieneMasRecursos($lineasDeProduccion[$i], $lineasDeProduccion[$i - 1])) {
            $crecimiento[] = $lineasDeProduccion[$i];
        }
    }
    return $crecimiento;
}
echo implode(",", lineasEnCrecimiento([1,3,4,2,5,6,8,3,10])) . "\n";
// PROPÓSITO: Devuelve las líneas de producción cuya cantidad de recursos es
// estrictamente mayor que la anterior. Incluyendo siempre la primera línea de
// producción como punto de partida.
// PRECONDICIÓN: $lineasDeProduccion no es vacía
// EJEMPLO: lineasEnCrecimiento([1,3,4,2,5,6,8,3,10]) = [1,3,4,5,6,8,10]

function procesarEnCadena(int $x, int $ciclos, callable $proceso, int $valorInicial): int {
    $resultado = $valorInicial;
    for ($i = 0; $i < $ciclos; $i++) {
        $resultado = $proceso($x, $resultado);
    }
    return $resultado;
}

$proceso = function(int $valor, int $acumulado): int {
    return sumarRecursos($acumulado, $valor);
};

echo procesarEnCadena(2, 4, $proceso, 5) . "\n";
// PROPÓSITO: Devuelve el resultado acumulado tras aplicar un proceso de la fábrica a lo
// largo de múltiples ciclos
function produccionEnParaleloHOF(int $y, int $lineasDeProduccion, callable $proceso2): int {
    $total = 0;
    for ($i = 0; $i < $lineasDeProduccion; $i++) {
        $total = $proceso2($y, $total);
    }
    return $total;
}
$proceso2 = function(int $cantidad, int $total): int {
    return sumarRecursos($cantidad, $total);
};
echo produccionEnParaleloHOF(5, 2, $proceso2) . "\n";
echo produccionEnParaleloHOF(5, 0, $proceso2) . "\n";

function produccionEnReplicadaHOF(int $z, int $lineasDeProduccion, callable $proceso2): int {
    $total = 1;
    for ($i = 0; $i < $lineasDeProduccion; $i++) {
        $total = $proceso2($total, $z);
    }
    return $total;
}
$proceso2 = function(int $cantidad, int $total): int {
    return sumarRecursos($cantidad, $total);
};
echo produccionEnReplicadaHOF(2, 3, $proceso2) . "\n";
echo produccionEnReplicadaHOF(3, 0, $proceso2) . "\n";
//Redefinir las funciones produccionEnParalelo y produccionReplicada con los nombres
//produccionEnParaleloHOF y produccionReplicadaHOF utilizando la función generalizada.

?>
