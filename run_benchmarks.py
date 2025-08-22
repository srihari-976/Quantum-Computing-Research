import os
import glob
from qiskit import QuantumCircuit, transpile
from qiskit_aer import Aer
from qiskit_ibm_runtime import QiskitRuntimeService, SamplerV2 as Sampler


def load_qasm_circuit(file_path):
    """Load OpenQASM file into a QuantumCircuit"""
    try:
        qc = QuantumCircuit.from_qasm_file(file_path)
        return qc
    except Exception as e:
        print(f"❌ Failed to load {file_path}: {e}")
        return None


def run_local(qc):
    """Run on local Aer simulator"""
    try:
        backend = Aer.get_backend("qasm_simulator")
        transpiled = transpile(qc, backend)
        job = backend.run(transpiled, shots=1024)
        result = job.result()
        return result.get_counts()
    except Exception as e:
        print(f"❌ Local simulation failed: {e}")
        return None


def run_ibm(qc, backend_name="ibmq_qasm_simulator"):
    """Run on IBM Quantum backend (requires saved IBM API key)"""
    try:
        service = QiskitRuntimeService()   # Assumes you ran service.save_account() before
        backend = service.backend(backend_name)

        transpiled = transpile(qc, backend)
        sampler = Sampler(backend)
        job = sampler.run([transpiled])
        result = job.result()
        
        # Extract measurement counts
        return result[0].data.meas.get_counts()
    except Exception as e:
        print(f"❌ IBM run failed: {e}")
        return None


def main():
    # Find all .qasm files
    qasm_files = glob.glob("*.qasm")
    if not qasm_files:
        print("⚠️ No QASM files found in current directory.")
        return

    print("✅ Running benchmarks...\n")
    for qasm_file in qasm_files:
        print(f"🚀 Running {qasm_file}...")
        qc = load_qasm_circuit(qasm_file)
        if qc:
            try:
                # Change run_local → run_ibm(qc) if you want cloud run
                counts = run_local(qc)
                if counts:
                    print(f"📊 Result for {qasm_file}: {counts}\n")
            except Exception as e:
                print(f"❌ Error running {qasm_file}: {e}")


if __name__ == "__main__":
    main()
