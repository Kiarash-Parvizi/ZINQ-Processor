# ZINQ Processor
a simple single-cycle processor designed for educational purposes

## run and test:
### make sure you have [Parvaj](https://github.com/machitgarha/parvaj) currectly installed by running:
```
git submodule update --init --recursive
cd scripts
composer install
```
### Requirements
```
- PHP 7.4+
- Composer
- GHDL
- GtkWave
```
### run unit-test
```
scripts/start-unit-test.php <test-entity-name> [<workdir>] [<simulation-options>]
```

## instruction-set
| type | OPC | funct | assembly-format | Operation |
| :--: | :-: | :---: | :-------------: | :------- |
| Z | 000 | ‐ | stoi Rd, Rs, Rt, Imm | Mem[Rs + Rt] ← 16×U.S(Rd) + Z.E(Imm) |
| Z | 001 | - | cmpi Rd, Rs, Rt, Imm | If (Rs == S.E(Imm))<br/>&nbsp;&nbsp;Rd ← 0x"FFFF"<br/>Else<br/>&nbsp;&nbsp;Rd ← 0x"0000"
| I | 010 | ‐ | ltor Rd, Imm, Shamt  | Rd ← (Mem[S.E(Imm & “0000”)) << (4 ^ Shamt))
| I | 011 | - | luis Rd, Imm, Shamt  | Rd ← (S.E(Imm) << Shamt )[15:8] & 0x"00"
| N | 111 | 01| bgti Imml, Immh, Addr | If (S.E(Imml) < S.E(Immh))<br/>&nbsp;&nbsp;PC ← (PC[15:12] & Bank[Addr][11:0])<br/>&nbsp;&nbsp;Bank[3] ← (PC + 2)<br/>Else<br/>&nbsp;&nbsp;PC ← (PC + 2)<br/>&nbsp;&nbsp;Bank[Addr] ← (PC + 2) |
| N | 111 | 10 | jalv Imml, Immh, Addr | PC ← (Z.E(Immh & Imml)<<1) + (PC + 2)<br/>Bank[Addr] ← (PC+2) |
| Q | 100 | - | subs Rd, Rs, Rt, Shamt | If (q == 1)<br/>&nbsp;&nbsp;Rd ← (Rs ‐ Rt) << Shamt<br/>Else<br/>&nbsp;&nbsp;Rd ← (U.S(Rs) ‐ U.S(Rt)) << Shamt |
Q | 110 | - | beon Rd, Rs, Rt, Shamt | If (q == 1)<br/>&nbsp;&nbsp;Rd ← Rs[15:8] & Rt[7:0]<br/>&nbsp;&nbsp;PC ← PC + ((Rs × 64) + (4 ^ Shamt))<br/>Else<br/>&nbsp;&nbsp;Rd ← NOT(Rs) <br/>&nbsp;&nbsp;PC ← (PC << Shamt) |

## instruction-format
![](about/single-cycle/instruction-format.jpg)

## data-path:
![](about/single-cycle/datapath.jpg)

## controller:
[//]: # "![](about/single-cycle/controller.jpg)"

