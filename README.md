# SignDocs: Flutter feature sample

This repository presents one document workflow as a compact example of my Flutter code and technical decisions.

Import an existing PDF, turn selected photos into a PDF, or scan pages with the device scanner. Documents are stored locally with generated previews. You can search and filter them, mark them as signed or unsigned, and share, print, or delete them. The signature is simulated as a document status; no cryptographic signing takes place.

## AI in my workflow

I use AI to explore approaches, speed up routine work, and review code. I do not delegate technical decisions to it: I inspect every line myself and take responsibility for what I keep. I also practice working with MCP, meta-prompting, orchestration, and agentic development workflows.

## Architecture

- **Presentation:** Flutter UI and Cubit state management.
- **Domain:** use cases, a repository contract, and explicit `Result`/`Failure` handling.
- **Data:** Drift persistence, managed file storage, PDF processing, and separate integrations for picking, scanning, sharing, and printing. File writes and cleanup are designed to handle partial failures.

## Run

```bash
flutter pub get
flutter run
```

