# Data Processing and Dataset Construction

## Objective

This chapter describes the construction of a training dataset for a
ground vibration attenuation model. The model relates the peak particle
velocity (PPV) and peak particle acceleration (PPA) recorded at
seismograph monitoring stations to the blast charge and the
source-to-station distance. The eight response variables targeted for
modelling are the three components of PPV (longitudinal, transversal,
vertical, in mm/s) and three components of PPA (longitudinal,
transversal, vertical, in g), from which the peak vector sum can also
be derived.

The dataset covers 86 station-event records across 21 blast events
monitored between August 2025 and February 2026 at the Impala BRPM TSF
site.

---

## Raw Data Sources

Three categories of documents were received from the project team:

- **Seismograph time series files** — continuous velocity recordings
  from 8 fixed and 2 mobile monitoring stations, in manufacturer-format
  TXT and CSV. Each file contains a structured instrument header
  followed by tabular waveform data.

- **Blast design documents** — timing design PDFs prepared by the blast
  contractor for each blast event, containing the block identification,
  mining group, and the maximum charge per delay used for vibration
  prediction.

- **PPV summary table** — a spreadsheet provided by the blast management
  team consolidating peak values, charges, and source-to-station
  distances for each monitored event.

---

## Data Extracted and Sources of Truth

### From the time series files (instrument source of truth)

The instrument header embedded in each recording provides:

- Station serial number (StationID)
- Trigger timestamp
- Sample rate (FS, sps)
- Peak particle velocity per component (ppvL, ppvT, ppvV)
- Peak particle acceleration per component (ppaL, ppaT, ppaV)

These values are written by the instrument at the time of recording and
are treated as the primary source of truth. Cross-checking against the
client summary table confirmed that the client's reported PPV and PPA
values are identical to those in the instrument headers, indicating the
client table was derived directly from the same recordings.

### From the blast design PDFs (blast design source of truth)

For each blast event, the design document provides:

- Block name (BlastID)
- Mining group (MG, integer 1–4)
- Maximum charge per delay (kg), stated as:
  *"Predictions are based on a max charge of X kg"*

### From the client PPV summary table (client-reported)

The only predictor not available from instrument files or blast design
documents is the **distance from each monitoring station to the blast
array (D)**. Blast array coordinates are not included in the design
documents, so the distance cannot be computed independently. D is
sourced from the client summary table and is explicitly documented as
a client-reported value.

All other client-reported fields (charge values, PPV, PPA) are retained
in a separate comparison table for audit purposes and are not used as
primary inputs to the model.

---

## Index Tables

Four index tables were constructed from the raw data. Together they
form the relational backbone of the dataset.

**RecordTable** — one row per time series file (86 rows)
Links each recording to its blast event, monitoring station,
instrument metadata, and peak values. D is the only client-sourced
field. Fields: FilenameTS, TSID, EventID, StationID, DateTime,
isSameEvent, FS, ppvL, ppvT, ppvV, ppaL, ppaT, ppaV, D.

**EventTable** — one row per detected blast event (21 rows)
Blast events are identified by timestamp clustering: recordings
triggering within 60 seconds of each other are assigned to the same
event. The EventID is the timestamp of the first trigger in the
cluster. Observed within-event trigger offsets range from 0 to 22
seconds. Fields: EventID, DateTime, StationCount, TSCount.

**BlastTable** — one row per blast design document (23 rows)
Extracted from the design PDFs. Maps each blast event (by date) to
its block name, mining group, and maximum charge. Fields:
FilenameBlast, Block, MG, MaxCharge (kg), DateBlast.

**StationTable** — one row per monitoring station (10 rows)
Station serial numbers, type (F = fixed, M = mobile), and coordinates
in the Hartebeeshoek94 Lo27 system. Coordinates for three fixed
stations (UM11515, UM12780, UM18612) were provided by the client
subsequent to the initial data delivery. Fields: StationID, Type, X, Y, Z.

---

## Data Excluded

The following recordings were excluded from the dataset following
review with the project team:

- **Six recordings on four dates** — the client confirmed that these
  triggers originated from blasting at an adjacent mine operation. No
  blast design information is available for these events and no
  distance or charge data can be assigned.

- **One mobile recording** (UM22666, 12 Sep 2025) — excluded per
  client instruction.

Three blast design documents corresponding to blast events prior to
the start of the monitoring programme were also removed from
processing.

---

## Time Series Processing

Each recording is processed as a self-contained event record. The
waveform columns (Tran, Vert, Long) are extracted directly from the
data section of each file; the air overpressure channel (MicL, in dB)
is excluded.

For each blast event, a trigger offset table is computed: the station
that triggered first is assigned offset t₀ = 0 and subsequent
stations are assigned the elapsed seconds from the first trigger.
This offset captures the wave travel time across the monitoring array
without modifying the individual time axis of each recording, which
always starts at zero.

Each recording is stored as a wide-format velocity table with columns:
t (s), VT.L, VT.T, VT.V (mm/s), EventID, StationID.

---

## Ambiguity: Maximum Charge Definition

The blast design PDFs report a single "maximum charge" value used for
PPV prediction. The client's summary table includes two charge fields:
Q (maximum charge per delay) and q (charge per hole). In response to
our query, the client clarified that the PDF value represents the
maximum charge mass firing within a 9 ms window, which may be one or
more holes depending on the timing design.

This leaves the maximum-charge assignment unresolved for two cases:

- **Dual-blast event (21 January 2026)**: two designs were fired as a
  single event. Two distinct charge values apply (222 kg and 138 kg).
  The client advises using the minimum distance and the corresponding
  maximum charge per delay for each design. This event requires
  separate treatment in scaled distance calculations.

- **Event of 20 February 2026 (Block 15.4.E & 16.4.E)**: no blast
  design PDF was received. Charge (212 kg) and distances were provided
  directly by the client.

Until the charge definition is confirmed as consistent across all
events, the PDF-derived charge (MaxCharge from BlastTable) and the
client-reported charge (Q.client from CompareTable) are maintained in
separate fields.

---

## Training Dataset Summary

The training dataset is assembled by joining RecordTable, BlastTable,
and StationTable. Each row represents one seismograph recording of one
blast event.

**Predictors:**

- D — source-to-station distance (m), client-reported (only exception
  to the source-of-truth principle; blast array coordinates are not
  available from design documents)
- MaxCharge — maximum charge per delay (kg), from blast design PDFs
- MG — mining group (1–4), from blast design PDFs
- Type — station type (F/M)
- X, Y — station coordinates (Hartebeeshoek94 Lo27)

**Responses (8 variables):**

- ppvL, ppvT, ppvV — peak particle velocity (mm/s)
- ppaL, ppaT, ppaV — peak particle acceleration (g)
- PVS — peak vector sum, derivable from ppvL, ppvT, ppvV

**Coverage:**

- 86 records, 21 events, 10 stations
- Distance range: 232 – 1,220 m
- Charge range: 43 – 305 kg (excluding the dual-blast case)
- All 86 records have complete PPV, PPA, D, and Q values
