# ⚙️ Împărțitor Non-Restoring și Componente ALU – VHDL
Implementarea algoritmului de împărțire **non-restoring** în VHDL, alături de o serie de componente de bază pentru un ALU. Întregul proiect a fost simulat și verificat în **ModelSim**.
## Componente Proiect
| Fișier | Descriere |
|---|---|
| `IMPARTITOR.vhd` | Blocul de top care coordonează algoritmul de împărțire non-restoring |
| `ControlUnit.vhd` | Unitatea de control (FSM) – se ocupă de sincronizare și semnalele de comandă |
| `ExecutionUnit.vhd` | Unitatea de execuție (calea de date) – realizează calculele propriu-zise |
| `AddSub.vhd` | Sumator / scăzător pe 8 biți |
| `sumpack.vhd` | Package VHDL cu definiții de tipuri și funcții auxiliare pentru sume |
| `PIPO.vhd` | Registru paralel (Parallel-In Parallel-Out) |
| `SHIFT_REG.vhd` | Registru de deplasare (Shift Register) |
| `numarator.vhd` | Numărător sincron pentru gestionarea pașilor algoritmului |
## Testbench-uri
| Fișier | Ce testează |
|---|---|
| `tb_impartitor.vhd` | Validarea algoritmului complet de împărțire |
| `addsub_tb.vhd` | Testarea blocului de adunare/scădere |
| `numarator_tb.vhd` | Verificarea funcționării numărătorului sincron |
## Mediu de Dezvoltare
- **Simulator:** ModelSim (analiză pe forme de undă / waveforms)
- **Standard:** VHDL '93

# ⚙️ Non-Restoring Divider & ALU Components – VHDL
A VHDL implementation of the **non-restoring division** algorithm, packaged with basic hardware blocks for a simple ALU. Fully simulated and verified using **ModelSim**.
## Project Components
| File | Description |
|---|---|
| `IMPARTITOR.vhd` | Top-level entity integrating the non-restoring divider |
| `ControlUnit.vhd` | Control unit (FSM) – handles execution timing and control signals |
| `ExecutionUnit.vhd` | Execution unit (datapath) – structural assembly of the math blocks |
| `AddSub.vhd` | 8-bit adder/subtractor block |
| `sumpack.vhd` | Custom VHDL package containing shared types and helper functions |
| `PIPO.vhd` | Parallel-In Parallel-Out register |
| `SHIFT_REG.vhd` | Shift register |
| `numarator.vhd` | Synchronous counter used to track algorithm steps |
## Testbenches
| File | Target Module |
|---|---|
| `tb_impartitor.vhd` | Complete end-to-end divider testbench |
| `addsub_tb.vhd` | Adder/subtractor verification |
| `numarator_tb.vhd` | Synchronous counter validation |
## Toolchain & Standards
- **Simulation:** ModelSim (waveform analysis)
- **Language Standard:** VHDL '93
