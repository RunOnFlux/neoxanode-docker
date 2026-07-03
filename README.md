# neoxanode-docker — HA Neoxa Smartnode for Flux

Upgrades the Neoxa smartnode image to the shared Flux **HA masternode template**
(2 instances, static IP, self-healing failover). Only `coin.env` is Neoxa-specific.

## Verified against source (NeoxaChain/Neoxa — Ravencoin base + Dash DIP3)
| value | setting | source |
|---|---|---|
| daemon / cli | `neoxad` / `neoxa-cli` | release payload |
| datadir | `/root/.neoxacore` | util.cpp:641 |
| conf | `neoxa.conf` | util.cpp:111 |
| MN port | **8788** | chainparams.cpp:438 (CMainParams nDefaultPort) |
| BLS key | `smartnodeblsprivkey` | rpcevo.cpp:1332; init.cpp:670 |
| collateral | 1,000,000 NEOX | chainparams.cpp:468 |
| model | DIP3/ProTx — `protx update_service` → ProUpServTx | rpc/rpcevo.cpp:793 |

## Notes
- Neoxa grafts Dash smartnodes/DIP3 onto a Ravencoin/KAWPOW base (has an asset layer),
  but `protx info` emits the same `.state.service` / `.state.PoSeBanHeight` keys, so the
  controller reads it unchanged.
- Binary pinned to **v5.2.0.0** (was 5.1.1.4 in the old image); use the `neoxad-*-linux64.zip`
  daemon asset, not the `neoxaqt-*` GUI.

## What changed vs the old image
- Old: single-behaviour, `key.sh`, no HA, no autoheal. **Removed.**
- New: `coin.env` + generic `node_initialize.sh` / `mn-autoheal.sh` / `check-health.sh`
  under supervisor. Marketplace entry moves to **v8, `instances: 2`, `staticip: true`**
  (see `neoxamn-v8.marketplace.json`, replaces the existing `NeoxaMN`).

## User inputs
`KEY` (operator BLS priv), `PROTXHASH`, plus a small NEOX fee balance sent once to the
fee-source address printed on startup.

## Not yet validated
Built + unit-tested (stubbed cli). Real `docker build` + testnet `protx update_service`
dry-run still pending.
