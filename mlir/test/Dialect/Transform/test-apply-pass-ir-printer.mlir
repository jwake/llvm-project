// RUN: mlir-opt %s --transform-interpreter -allow-unregistered-dialect --mlir-print-ir-after-all --verify-diagnostics 2>&1 | FileCheck %s

// CHECK-LABEL{LITERAL}: IR Dump After Canonicalizer
// CHECK-LABEL{LITERAL}: IR Dump After Canonicalizer
// CHECK-LABEL{LITERAL}: IR Dump After Canonicalizer
// CHECK-LABEL{LITERAL}: IR Dump After InterpreterPass

// CHECK-LABEL: func @successful_pass_application(
//       CHECK:   %[[c5:.*]] = arith.constant 5 : index
//       CHECK:   return %[[c5]]
func.func @successful_pass_application(%t: tensor<5xf32>) -> index {
  %c0 = arith.constant 0 : index
  %dim = tensor.dim %t, %c0 : tensor<5xf32>
  return %dim : index
}

module attributes {transform.with_named_sequence} {
  transform.named_sequence @__transform_main(%arg1: !transform.any_op) {
    %1 = transform.structured.match ops{["func.func"]} in %arg1 : (!transform.any_op) -> !transform.any_op
    %2 = transform.apply_registered_pass "canonicalize" to %1 : (!transform.any_op) -> !transform.any_op
    %3 = transform.apply_registered_pass "canonicalize" to %2 : (!transform.any_op) -> !transform.any_op
    transform.apply_registered_pass "canonicalize" to %3 : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}
