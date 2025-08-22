// Grover Smoke Test (2 qubits) — target |11>
OPENQASM 2.0;
include "qelib1.inc";
qreg q[2];
creg c[2];
h q[0]; h q[1];
barrier q;
h q[1]; cx q[0], q[1]; h q[1];
barrier q;
h q[0]; h q[1]; x q[0]; x q[1];
h q[1]; cx q[0], q[1]; h q[1];
x q[0]; x q[1]; h q[0]; h q[1];
barrier q;
measure q[0] -> c[0];
measure q[1] -> c[1];
