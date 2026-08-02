# RESEARCH — Primer deployment con qrt (AR-S2J2J.X)

Fecha: 2026-07-20. Frente E135-A6o. Solo lectura: helps de `qrt deploy`,
fuente `/usr/local/bin/qrt` (bash, 54 KB), manifests y registros de proyectos
hermanos (AR-S2L1W, AR-SABJ0.R, AR-SABP0.R). Sin mutaciones Netlify.

## Cómo funciona qrt deploy

- **Modelo**: cada artefacto HTML del proyecto se publica como un sitio
  Netlify propio, identificado por un `alias` local. El mapeo
  `alias=<uuid-del-sitio>` vive en **`.netlify/sites.env`** en la raíz del
  repo (¡versionado en git en los hermanos, junto con `.netlify/netlify.toml`!).
- **Manifest** `qrt.manifest.json` (raíz del repo, `schemaVersion: 2`); campos
  por artefacto: `alias`, `kind` (`quarto|map|static`), `path` (directorio a
  publicar), `renderSource`, `profile`, `required`, y opcionales `siteSlug`
  (nombre del sitio Netlify; requerido solo para `deploy init --manifest`) y
  `domain` (para `deploy domain --manifest`).
- **Outputs esperados**: qrt renderiza book/revealjs/html a `html/<stem>/`
  (index.html) y docx a `docx/`. `render --manifest` verifica
  `<path>/index.html` por artefacto (`required: false` ⇒ SKIP en vez de ERROR).
- **`deploy init`** (una sola vez): busca cada `siteSlug` con
  `netlify sites:list`; con `--create` crea los faltantes
  (`netlify sites:create --manual --disable-linking --name <slug>
  [--account-slug <team>]`) y escribe `alias=uuid` en `.netlify/sites.env`.
  Fail-closed: valida todo antes de mutar y **se niega a re-apuntar** un alias
  existente a otro sitio.
- **`deploy`**: por artefacto ejecuta `netlify deploy --dir=<path>
  --site=<uuid> --no-build`; **sin `--prod` es draft** (URL de preview);
  con `--prod` publica a producción.
- **`deploy domain`**: liga `domain` al sitio vía `netlify api updateSite`
  (verifica el dominio actual primero; no pisa conflictos) y con `--https`
  aprovisiona el certificado TLS (`provisionSiteTLSCertificate`, con retry).
- Todos los subcomandos manifest aceptan `--dry-run`, `--only <aliases>`,
  `--except <aliases>`.
- Formas por alias para casos puntuales: `qrt deploy init <alias> <site-name>
  [--create]`, `qrt deploy <alias> <dir> [--prod]`,
  `qrt deploy domain <alias> <domain> [--https]`.

## Prerrequisitos verificados en esta máquina

- `netlify` CLI: `/usr/local/bin/netlify` ✓
- Autenticación Netlify: `~/Library/Preferences/netlify/config.json` presente ✓
- `jq`: `/opt/homebrew/bin/jq` ✓ (qrt lo usa para todo el parsing)
- Repo git ✓ (qrt deploy hace `cd` a la raíz git)
- Artefactos HTML ya existentes: `html/report.es/`, `html/report.en/`,
  `html/ppt/` ✓ (el propietario está re-renderizando)

## Estado del proyecto

AR-S2J2J.X **no tiene** `qrt.manifest.json` ni `.netlify/sites.env`: primer
deployment confirmado. Artefactos publicables: `report.es` (book),
`report.en` (book), `ppt` (revealjs). Los DOCX (`summary.*`, memos) son
entregables de archivo, no sitios.

## Manifest propuesto (plantilla; slugs/domains a decisión del propietario)

```json
{
  "schemaVersion": 2,
  "artifacts": [
    { "alias": "report.es", "kind": "quarto", "path": "html/report.es",
      "required": true, "renderSource": "report.es.qmd", "profile": "book",
      "siteSlug": "<slug-es>" },
    { "alias": "report.en", "kind": "quarto", "path": "html/report.en",
      "required": true, "renderSource": "report.en.qmd", "profile": "book",
      "siteSlug": "<slug-en>" },
    { "alias": "ppt", "kind": "quarto", "path": "html/ppt",
      "required": true, "renderSource": "ppt.qmd", "profile": "revealjs",
      "siteSlug": "<slug-ppt>" }
  ]
}
```

Convención de slugs observada en hermanos: `arsabp0-ppt` (prefijo de proyecto
en minúsculas). Sugerencia: `ars2j2j-report-es`, `ars2j2j-report-en`,
`ars2j2j-ppt`. Los nombres Netlify son globales y únicos. `domain` puede
agregarse después (patrón existente: `model-ldv.srk.ar` en otro proyecto).

## Secuencia exacta del primer deployment

```text
1. Escribir qrt.manifest.json (slugs decididos por el propietario)
2. qrt render --manifest qrt.manifest.json --dry-run      # verifica outputs
3. qrt deploy init --manifest qrt.manifest.json --dry-run # plan de sitios
4. qrt deploy init --manifest qrt.manifest.json --create  # crea sitios + sites.env
5. qrt deploy --manifest qrt.manifest.json                # DRAFT (previews)
6. inspección de las URLs de preview por el propietario
7. qrt deploy --manifest qrt.manifest.json --prod         # producción
8. (opcional) qrt deploy domain --manifest ... --dry-run  # plan de dominios
9. (opcional) qrt deploy domain --manifest ... --https    # bind + TLS
10. commit de qrt.manifest.json y .netlify/ (patrón de los hermanos)
```

Si la cuenta Netlify tiene más de un team, pasar `--account <slug>` en el
paso 4. Para dominios `*.srk.ar` el DNS debe apuntar al sitio Netlify
(CNAME al `<site>.netlify.app`; los sitios se crean `--manual`): no
verificable localmente — confirmar contra la configuración DNS usada por los
proyectos ya publicados.

## Decisiones pendientes del propietario

1. Slugs de los tres sitios (sugerencia arriba).
2. ¿Dominios `srk.ar` ahora o después? Y cuáles.
3. ¿`--account` necesario? (si hay múltiples teams en la cuenta).
4. Confirmar el go de ejecución: los pasos 4, 5, 7 y 9 crean sitios y
   publican contenido en Netlify (acción externa; requiere aprobación
   explícita paso a paso o en bloque).
