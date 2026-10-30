# blockchain-syslog-audit

Inmutabilidad y trazabilidad de logs de auditoría mediante **Blockchain privada (Proof-of-Authority)** y **árboles de Merkle**, frente a la técnica **MITRE ATT&CK T1070 (Indicator Removal on Host)**.

Material complementario del Trabajo Práctico Final de *Metodología de la Investigación* (Licenciatura en Ciberseguridad, Universidad del Gran Rosario).

**Autores (Grupo M):** Lautaro Valentín Espinosa · Mario Martín Graffi

> ⚠️ **Aviso sobre los datos:** los resultados cuantitativos del informe (tasas de alteración, latencia, throughput, consumo de recursos y pruebas estadísticas) son **sintéticos**, generados con fines académicos conforme a lo acordado con la cátedra. Este repositorio contiene el diseño de referencia y fragmentos de código ilustrativos; no incluye mediciones de una corrida real. El dashboard de `docs/` es un mockup.

## Problema

Un servidor Syslog centralizado es un punto único de falla: con credenciales `root`/`SYSTEM`, un atacante puede alterar o borrar los registros locales y remotos para ocultar su intrusión.

## Arquitectura propuesta

- **Off-chain:** los logs (RFC 5424) se almacenan fuera de la cadena.
- **On-chain:** solo la **Merkle Root** de cada lote se registra en una red PoA (Geth/Clique, 4 validadores).
- **Auditor criptográfico:** compara hashes SHA-256 y verifica cada log contra la raíz anclada con complejidad O(log N).

La solución hace **evidente** la manipulación (*tamper-evident*); no impide borrar la copia local ni protege logs aún no anclados (ver sección de limitaciones del informe).

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `docker-compose.yml` | Fragmento ilustrativo del testbed: nodo Geth PoA y servidor Syslog tradicional. Solo para entorno aislado. |
| `LogRegistry.sol` | Contrato inteligente (Solidity 0.8.20) que registra la Merkle Root, la fecha y la cantidad de logs de cada lote. Solo el `owner` puede registrar lotes. |
| `attack_simulation.py` | Fragmento simplificado que simula la alteración de 5.000 registros (T1070) con semilla fija (`seed = 42`). |
| `docs/` | Figuras del informe (mockup del dashboard con datos sintéticos). |

## Entorno de referencia

- Ubuntu 22.04 · Docker / Docker Compose
- Go-Ethereum (Geth), consenso Clique (EIP-225)
- Solidity 0.8.20
- Python 3.11
- Locust (generación de tráfico) y Grafana / Prometheus (monitoreo, diseño propuesto)

## Uso (referencia)

```bash
# Levantar el testbed ilustrativo
docker compose up -d

# Simulación de alteración T1070 (fragmento simplificado)
python3 attack_simulation.py
```

> El `docker-compose.yml` incluye solo el nodo 1 de 4 y no está pensado para producción: expone el RPC y usa `--allow-insecure-unlock`. Úselo exclusivamente en una red aislada de pruebas.

## Diseño experimental (resumen)

- Cuasi-experimental, enfoque cuantitativo, alcance explicativo.
- Muestra: 50.000 logs RFC 5424 y 5.000 intentos de alteración por arquitectura.
- Tamaños de lote evaluados: N ∈ {100, 500, 1000}.
- Hipótesis: 0 % de alteración inadvertida con degradación de latencia < 15 %. Resultado del informe: **H₁ se acepta parcialmente** (inmutabilidad confirmada; el umbral de latencia no se cumple en escritura sincrónica on-chain).

## Consideraciones éticas y legales

Entorno experimental aislado, sin datos reales de usuarios ni organizaciones. Marco: Ley 26.388 (Argentina) e ISO/IEC 27037:2012.

## Referencias principales

- Gerhards, R. (2009). *The Syslog Protocol* (RFC 5424).
- Szilágyi, P. (2017). *EIP-225: Clique proof-of-authority consensus protocol*.
- MITRE ATT&CK. *Indicator Removal on Host (T1070)*.
- NIST SP 800-92 (2006), *Guide to Computer Security Log Management*.

Lista completa en el informe final.
