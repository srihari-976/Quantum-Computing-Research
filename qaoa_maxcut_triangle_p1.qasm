// QAOA MaxCut on triangle graph (3 nodes), p=1, fixed angles
// Angles chosen heuristically: gamma=pi/4, beta=pi/8
OPENQASM 2.0;
include "qelib1.inc";
qreg q[3];
creg c[3];
// Initial state |+>^3
h q[0]; h q[1]; h q[2];
barrier q;
// Cost unitary U_C(gamma) with ZZ on edges (0-1), (1-2), (0-2)
u1(3.1415926536/4) q[1];    // global phases ignored; implement ZZ via CNOT-RZ-CNOT
cx q[0], q[1]; rz(3.1415926536/4) q[1]; cx q[0], q[1];
cx q[1], q[2]; rz(3.1415926536/4) q[2]; cx q[1], q[2];
cx q[0], q[2]; rz(3.1415926536/4) q[2]; cx q[0], q[2];
barrier q;
// Mixer U_B(beta): Rx on each qubit
rx(3.1415926536/8) q[0];
rx(3.1415926536/8) q[1];
rx(3.1415926536/8) q[2];
barrier q;
// Measure
measure q[0] -> c[0];
measure q[1] -> c[1];
measure q[2] -> c[2];
