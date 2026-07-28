# ProjectWise Saved Search Manager 🔍

A standardized PowerShell automation utility designed to provision structured, ISO 19650-compliant saved searches across Bentley ProjectWise templates and active engineering projects.

---

## Overview

Configuring saved searches manually for every project environment or template is repetitive and prone to human error. This automation script creates a comprehensive hierarchy of saved searches mapped directly to discipline-specific workflows (Drawings, Models, Documents) and document lifecycle states (WIP, Check, Shared, Published).

---

## Key Features

- ⚡ **Automated Provisioning:** Instantly sets up a full tree of structured saved searches in a single execution.
- 📐 **ISO 19650 Alignment:** Standardizes search filters across project environments and lifecycle gates.
- 🔄 **Flexible Targeting:** Supports both global template environments and active project deployment structures.

---

## Prerequisites

- **ProjectWise PowerShell Module:** `PWPS_DAB` installed and loaded.
- **Authentication Credentials:** Active GUI or IMS login permissions to the target datasource.
- **Cleanup Notice:** Ensure any outdated or incorrect existing saved searches within the target folder are manually cleared prior to running the script to prevent duplication conflicts.

---

## Usage Guide

### 1. Adding Saved Searches to Templates
1. Open PowerShell with the `PWPS_DAB` module active.
2. Run the script passing your target template name:
   ```powershell
   .\Add-PWSavedSearches.ps1 -TargetName "YourTemplateName"
