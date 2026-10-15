# Banker's Algorithm in Bash

A Bash script that runs the **Banker's algorithm**, which operating systems use to avoid deadlock. Written for my second-year university coursework (2024/25).

## What it does
1. Asks for the number of processes and resource types
2. Takes the available resources, the maximum demand and the current allocation for each process
3. Works out the **Need** matrix (Max − Allocation) and prints all the tables
4. Runs the safety algorithm and prints either a **safe sequence** (e.g. `P1 P3 P0 P2`) or a warning that the state is unsafe
5. Lets you add new processes. A new process is only accepted if the system stays safe; otherwise the request is rolled back

## How to run
```bash
chmod +x bankers.sh
./bankers.sh
```
Runs on Linux, macOS, or Windows with Git Bash / WSL.
