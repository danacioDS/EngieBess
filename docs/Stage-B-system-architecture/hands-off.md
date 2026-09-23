Perfecto. Aquí tienes la **secuencia completa de comandos** para cerrar Stage B en el repo: desde la limpieza de archivos hasta el último tag.

---

## 🛠️ PASO 1 — Limpieza previa de archivos contaminados

Primero hay que borrar `hands-off.md` (que está contaminado con meta-contenido) y renombrar `06-Databricks.md` a `06-databricks-arch.md`.

---

### 1.1 — Borrar el archivo contaminado

```
cd ~/repo_lab/EngieBess

rm docs/Stage-B-system-architecture/hands-off.md
```

### 1.2 — Renombrar B.6 al nombre canónico

```
git mv docs/Stage-B-system-architecture/06-Databricks.md docs/Stage-B-system-architecture/06-databricks-arch.md
```

Si `git mv` falla porque el archivo nunca fue trackeado, usa:

```
mv docs/Stage-B-system-architecture/06-Databricks.md docs/Stage-B-system-architecture/06-databricks-arch.md
```

---

## 🛠️ PASO 2 — Limpiar el contenido de B.6

El archivo `06-databricks-arch.md` contiene el B.6 v0.4 **pero con el preámbulo meta y las instrucciones de commit pegadas**. Hay que reemplazar todo el contenido por el B.6 v0.4 limpio que te di.

Abre el archivo:

```
nano docs/Stage-B-system-architecture/06-databricks-arch.md
```

Borra **todo** el contenido y pega el **B.6 v0.4 completo limpio** (el que empieza con `# B.6 Databricks Architecture v0.4 — Baseline (Frozen)` y termina en `**Engagement:** RFP-264144-1`).

Guarda el archivo.

**Verifica que quedó limpio:**

```
head -10 docs/Stage-B-system-architecture/06-databricks-arch.md
grep -c "📄 DOCUMENTO 1\|git add\|git commit" docs/Stage-B-system-architecture/06-databricks-arch.md
```

**Esperado:**

- `head -10` muestra el título de B.6 v0.4 limpio
- `grep -c` devuelve **0** (no hay meta-contenido)

---

## 🛠️ PASO 3 — Actualizar el índice maestro

Reemplaza el contenido de `STAGE-B-HLD-INDEX-001.md` con la **v0.2 Baseline Frozen** que te di.

```
nano docs/Stage-B-system-architecture/STAGE-B-HLD-INDEX-001.md
```

Borra todo y pega el contenido completo de la v0.2.

**Verifica:**

```
head -10 docs/Stage-B-system-architecture/STAGE-B-HLD-INDEX-001.md
grep -E "^\*\*Version:|^\*\*Status:" docs/Stage-B-system-architecture/STAGE-B-HLD-INDEX-001.md | head -2
```

**Esperado:**

- Version: `0.2 — Baseline (Frozen)`
- Status: `Stage B — Baseline (Frozen)`

---

## 🛠️ PASO 4 — Crear el Stage B → Stage C Handoff

Crea el archivo nuevo con el handoff completo:

```
nano docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md
```

Pega el **Stage B → Stage C Handoff v0.1** completo que te di.

Guarda el archivo.

**Verifica:**

```
head -10 docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md
```

**Esperado:** Título "STAGE-B-TO-C-HANDOFF-001 — Stage B → Stage C Handoff".

---

## 🛠️ PASO 5 — Commit 1: B.2 v0.5.1 freeze

```
cd ~/repo_lab/EngieBess

git add docs/Stage-B-system-architecture/02-model-arch.md

git commit -m "docs(stage-b): freeze B.2 Model Architecture v0.5.1

Bumps B.2 from v0.5 to v0.5.1 (settlement interface patch).

Consolidated changes in v0.5.1:
- §4.2 Load & Market Model: added Input 'Dispatch → attribution basis (for settlement)' and Output '→ Financial Engine: settlement basis'; added 'Note on dual role'
- §4.2 Lifecycle: Execution now includes 'execute market/program adapters on attribution basis'
- §4.5 Dispatch Engine: added Output '→ Load & Market Model: attribution basis (for settlement)'; reformulated Financial row to 'attribution basis (streams not requiring market settlement, if any)'
- §4.7 Financial Engine: added Input '← Load & Market Model: settlement basis'
- §5.1: Load & Market Model reason = 'Signals are inputs; settlement is a pure function'
- §7.2 Interface Matrix: added two rows (Dispatch → Load & Market, Load & Market → Financial)
- §7.3 Interface Timing: added two rows for settlement interfaces
- §8.2 Lifecycle per Object: Load & Market Model Execution includes market/program adapters
- §13 Change Log: new §13.2 for v0.5 → v0.5.1; version history updated

Required by B.4 §4.4 (adapter ownership and settlement flow).

Refs: B.2-MODEL-ARCH-001
Next: B.6 v0.4 freeze → B.2 → C handoff"

git push origin main
```

**Nota:** No crees tag todavía. El tag `stage-b-b2-v051-baselined` que ya existe puede apuntar a este commit o a otro. Lo verificamos al final.

---

## 🛠️ PASO 6 — Commit 2: B.6 v0.4 freeze

```
git add docs/Stage-B-system-architecture/06-databricks-arch.md

git commit -m "docs(stage-b): freeze B.6 Databricks Architecture v0.4

Bumps B.6 from v0.3 (Architecture Review Candidate) to v0.4 (Baseline Frozen).

Consolidated changes in v0.4:
- Job / Task / Workspace / Environment class definitions aligned with Databricks semantics
- Compute realization split into serverless compute, classic / provisioned compute, and serverless application infrastructure
- Classic compute framed as 'where required by workload, platform constraints, or approved enterprise requirements'; concrete requirement to Stage C
- Annual sequence realized as a loop within the scenario-batch job (not separate workflow runs per year)
- Parallelization mechanism: intra-task distributed fan-out; initial realization expected to use Spark grouped execution; partitioning to Stage C
- Scenario-batching model: scenario batches advance year by year in unison; workflow-level fan-out reserved for scenario batches
- Synchronization barriers: end-of-year barrier (annual state update) and end-of-scenario barrier (Tariff + Settlement in parallel, Financial after both)
- Write-at-barrier rule: grouped execution results written once per barrier
- Application identity now includes permission to trigger execution jobs
- HLD boundary rule: B.6 freezes the platform architecture, not the implementation topology
- Deferrals expanded (Job / Task topology, Spark partitioning, service boundary realization)

Renamed file: 06-Databricks.md → 06-databricks-arch.md.
Removed contaminated meta-content previously present in the file.

B.6 is now FROZEN as the Databricks realization baseline for Stage B.

Refs: B.6-DBX-ARCH-001
Next: STAGE-B-HLD-INDEX-001 v0.2 + Stage B → C Handoff"

git push origin main
```

---

## 🛠️ PASO 7 — Commit 3: STAGE-B-HLD-INDEX-001 v0.2

```
git add docs/Stage-B-system-architecture/STAGE-B-HLD-INDEX-001.md

git commit -m "docs(stage-b): update STAGE-B-HLD-INDEX-001 to v0.2 (Baseline Frozen)

Full rewrite of the Stage B master index.

Changes:
- Lists the 7 Stage B architectural views (B.0–B.6) with their frozen versions
- Declares the dependency chain (no view cites a Candidate)
- Declares Stage B scope and non-scope
- Declares Stage B closure criteria
- Declares Stage B closure status (all views frozen; handoff pending)
- Removed duplicate draft content from v0.1

Status: Baseline (Frozen).

Refs: STAGE-B-HLD-INDEX-001
Next: STAGE-B-TO-C-HANDOFF-001"

git push origin main

git tag -a stage-b-index-baselined -m "Stage B — Master Index v0.2 (Baseline Frozen)"
git push origin stage-b-index-baselined
```

---

## 🛠️ PASO 8 — Commit 4: Stage B → Stage C Handoff

```
git add docs/Stage-B-system-architecture/STAGE-B-TO-C-HANDOFF-001.md

git commit -m "docs(stage-b): produce Stage B → Stage C Handoff v0.1

Formal handoff from Stage B (System Architecture) to Stage C
(Detailed Specification).

Contents:
- Stage B closure declaration
- What Stage C receives from B.0–B.6 (consolidated)
- What Stage C must produce (physical, algorithmic, financial, platform, testing specifications)
- What Stage C must not redecide (frozen Stage B decisions)
- What remains open for Stage C (39 consolidated deferrals)
- Stage C entry point (Stage C Plan)
- Handoff sequence diagram

Status: Draft for Review.

Stage B is now CLOSED.

Refs: STAGE-B-TO-C-HANDOFF-001
Next: Stage C Plan"

git push origin main

git tag -a stage-b-closed -m "Stage B — Closed (B.0–B.6 frozen + handoff produced)"
git push origin stage-b-closed
```

---

## 🛠️ PASO 9 — Corregir el tag de B.6

El tag `stage-b-b6-baselined` que existe apunta a un commit que **no contiene B.6**. Hay que borrarlo y recrearlo apuntando al commit correcto (el del Paso 6).

**Borrar el tag actual (local y remoto):**

```
git tag -d stage-b-b6-baselined
git push origin :refs/tags/stage-b-b6-baselined
```

**Recrear el tag apuntando al commit correcto:**

```
git tag -a stage-b-b6-baselined -m "Stage B — B.6 Databricks Architecture v0.4 (Baseline Frozen)" <SHA-del-commit-B.6>
git push origin stage-b-b6-baselined
```

Para obtener el SHA del commit de B.6:

```
git log --oneline -10
```

Busca el commit con mensaje `docs(stage-b): freeze B.6 Databricks Architecture v0.4` y copia su SHA.

---

## 🛠️ PASO 10 — Verificación final del árbol de Stage B

```
cd ~/repo_lab/EngieBess

# 1. Listar archivos
ls -1 docs/Stage-B-system-architecture/

# 2. Ver versiones
for f in docs/Stage-B-system-architecture/*.md; do
  echo "=== $f ==="
  grep -E "^\*\*Version:|^\*\*Status:" "$f" | head -2
done

# 3. Ver tags
git tag -l | grep stage-b

# 4. Ver últimos commits
git log --oneline -12

# 5. Estado del working tree
git status
```

**Esperado:**

**Archivos:**

```
00-integrated-system.md
01-data-arch.md
02-model-arch.md
03-optimization-arch.md
04-financial-arch.md
05-software-arch.md
06-databricks-arch.md
STAGE-B-HLD-INDEX-001.md
STAGE-B-TO-C-HANDOFF-001.md
```

**Versiones:**

- B.0 → v0.3.3 Baseline (Frozen)
- B.1 → v0.3 Baseline (Frozen)
- B.2 → v0.5.1 Baseline (Frozen)
- B.3 → v0.6 Baseline (Frozen)
- B.4 → v0.4 Baseline (Frozen)
- B.5 → v0.4 Baseline (Frozen)
- B.6 → v0.4 Baseline (Frozen)
- Índice → v0.2 Baseline (Frozen)
- Handoff → v0.1 Draft for Review

**Tags (todos presentes):**

```
stage-b-b0-baselined
stage-b-b1-baseline-candidate
stage-b-b2-v051-baselined
stage-b-b3-baselined
stage-b-b4-baselined
stage-b-b5-baselined
stage-b-b6-baselined
stage-b-index-baselined
stage-b-closed
```

**Working tree:** `nothing to commit, working tree clean`

---

## 📋 Resumen de la secuencia

| # | Acción | Resultado |
|---|--------|-----------|
| 1 | Borrar `hands-off.md` + renombrar `06-Databricks.md` → `06-databricks-arch.md` | Archivos limpios |
| 2 | Limpiar B.6 de meta-contenido | B.6 v0.4 limpio |
| 3 | Actualizar índice a v0.2 | Índice maestro actualizado |
| 4 | Crear handoff | Stage B → C Handoff en repo |
| 5 | Commit B.2 v0.5.1 | Freeze de B.2 |
| 6 | Commit B.6 v0.4 | Freeze de B.6 |
| 7 | Commit índice v0.2 + tag | Freeze del índice |
| 8 | Commit handoff + tag | Stage B cerrado |
| 9 | Corregir tag B.6 | Tag apunta al commit correcto |
| 10 | Verificación final | Todo consistente |

---

## 🚦 Después de ejecutar todo

Cuando los 10 pasos estén completos y el árbol esté limpio:

**Stage B queda cerrado. Podemos arrancar Stage C.**

El siguiente documento natural es el **Stage C Plan**, que describe:

- Los deliverables de Stage C
- El orden de especificación
- El proceso de revisión y freeze de Stage C
- Los criterios del Stage C → Stage D Handoff

