# VENDO

**A Vending Machine Simulation in 8086 Assembly**

> Assembly Language course project — written in TASM for DOS.

---

## About the Project

VENDO is a console-based vending machine program that simulates a simple purchase cycle. The user picks a product, inserts money, and receives the calculated change, while the machine keeps track of stock and total sales.

### How it works

1. **Show menu:** displays the five products with their price and remaining stock.
2. **Choose product:** reads a number and validates that it is from 1 to 5.
3. **Check stock:** if the product is sold out, shows a message and returns to the menu.
4. **Insert money:** reads the amount and compares it with the price.
5. **Complete sale:** calculates the change, reduces the stock by one, and adds the price to total sales.
6. **Continue or exit:** asks `Another purchase? (y/n)`; on exit it prints the total sales for the session.

### Products

| # | Product | Price | Initial stock |
|---|---|---|---|
| 1 | Water | 5 | 5 |
| 2 | Juice | 10 | 5 |
| 3 | Chips | 8 | 5 |
| 4 | Biscuits | 6 | 5 |
| 5 | Chocolate | 12 | 5 |

### Input validation

| Case | Behavior |
|---|---|
| Choice below 1 or above 5 | Prints `Invalid choice!` and returns to the menu |
| Product out of stock | Prints an out-of-stock message and returns to the menu |
| Money less than the price | Prints `Not enough money! Money returned.` and returns to the menu |
| Valid purchase | Prints a success message and the change, then updates stock and sales |

### Code structure

| Part | Responsibility |
|---|---|
| `main` | Controls the whole flow: menu, selection, stock check, payment, sale, exit |
| `show_menu` | Prints each product with its number, price, and stock |
| `read_num` | Reads digits from the keyboard until Enter and converts them to a number in `AX` |
| `print_num` | Prints the unsigned number in `AX` as decimal digits |
| `printstr` (macro) | Prints a `$`-terminated string using DOS `int 21h`, function `09h` |

### Assembly concepts used

- Data segment initialization (`mov ax, @data` / `mov ds, ax`)
- Indexed addressing with parallel arrays (`prices[si]`, `stock[si]`)
- Procedures and the stack (`call`, `ret`, `push`, `pop`)
- DOS interrupts (`int 21h`) for input, output, and program exit
- Arithmetic and branching (`mul`, `div`, `cmp`, conditional jumps)

---

## Folder Contents

| File | Description |
|---|---|
| `vendo.asm` | Main source code of the VENDO program. |
| `VENDO.OBJ` | Object file produced by assembling `vendo.asm`. |
| `VENDO.EXE` | Compiled executable, ready to run under DOS or DOSBox. |
| `VENDO_Project_Presentation.pdf` | Project presentation: overview, goals, catalog, workflow, code structure, and conclusion. |
| `sec_1.asm` | Empty program skeleton (section exercise template). |
| `README.md` | This file. |

---

## How to Run

Run the executable directly in DOS or [DOSBox](https://www.dosbox.com/):

```
VENDO.EXE
```

To build it from source with TASM and TLINK:

```
tasm vendo.asm
tlink vendo.obj
vendo.exe
```

---

## Possible Improvements

- Add an admin mode to restock products
- Validate empty input and numeric overflow
- Keep a transaction history
- Print a clearer receipt summary
- Handle invalid payment input better

---

## Authors

- Abdullah Mohamed El-Sayed
