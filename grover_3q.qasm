// Grover Test (3 qubits) — target |101>
OPENQASM 2.0;
include "qelib1.inc";
qreg q[3];
creg c[3];
// Superposition on 3 qubits
h q[0]; h q[1]; h q[2];
barrier q;
// Oracle for |101>: flip phase on |101>
// Build with X on control zeros to map |101> to |111>, then CCZ via H-CX-CX-H
x q[1];       // q1 is 0 in target, so X
h q[2];
cx q[0], q[2];
cx q[1], q[2];
t q[2]; tdg q[2]; // (placeholder no-op to keep depth uniform on some transpilers)
cx q[1], q[2];
cx q[0], q[2];
h q[2];
x q[1];
barrier q;
// Diffuser
h q[0]; h q[1]; h q[2];
x q[0]; x q[1]; x q[2];
// CCZ on |111> via H on q2
h q[2]; cx q[0], q[2]; cx q[1], q[2]; h q[2];
x q[0]; x q[1]; x q[2];
h q[0]; h q[1]; h q[2];
barrier q;
measure q[0] -> c[0];
measure q[1] -> c[1];
measure q[2] -> c[2];
