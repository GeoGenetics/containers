# Conda package test container

An Ubuntu 24.04 container for checking whether Conda packages can be resolved and installed in a clean environment. It uses Miniconda and defaults to the `conda-forge` channel.

## Test locally

Build the image:

```bash
docker build --tag conda-package-tester .
```

Test one or more package specifications:

```bash
docker run --rm conda-package-tester samtools=1.21
docker run --rm conda-package-tester python=3.12 numpy pandas
```

Add channels in priority order. For Bioconda packages, use `conda-forge` before `bioconda`:

```bash
docker run --rm conda-package-tester \
  --channel conda-forge --channel bioconda \
  samtools=1.21
```

The command succeeds only if Conda can solve the requested environment and install all packages. The resulting package list is printed to the log.

## GitHub Actions

Use **Actions → Test Conda package → Run workflow**, enter package specifications separated by spaces, and optionally supply channels separated by spaces. The workflow builds the same Ubuntu image and runs the requested test.

Examples:

- Packages: `samtools=1.21`
- Channels: `conda-forge bioconda`
