# Conda package build container

An Ubuntu 24.04 container for building Conda packages in a clean environment. It includes Miniconda and `conda-build`, supports both x86_64 and ARM64 hosts, and keeps the host source tree outside the image.

## Build a package locally

Build the image:

```bash
docker build --tag conda-package-builder .
```

Mount the directory containing your source code and recipe. The mounted directory is available at `/work`:

```bash
docker run --rm -it \
  --volume "$PWD":/work \
  conda-package-builder \
  conda build recipe
```

For a recipe in a different directory, mount it explicitly:

```bash
docker run --rm -it \
  --volume /path/to/project:/work \
  conda-package-builder \
  conda build /work/recipe
```

`conda build` creates its build and output directories inside the container by default. To retain the built packages on the host, mount a local output directory and provide it to Conda:

```bash
mkdir -p conda-bld
docker run --rm -it \
  --volume "$PWD":/work \
  --volume "$PWD/conda-bld":/conda-bld \
  conda-package-builder \
  conda build --croot /conda-bld recipe
```

The helper that only tests whether packages can be installed remains available as `test-conda-package`.

## GitHub Actions

Use **Actions → Test Conda package → Run workflow**, enter package specifications separated by spaces, and optionally supply channels separated by spaces. The workflow builds the same Ubuntu image and runs the requested installation test.

Examples:

- Packages: `samtools=1.21`
- Channels: `conda-forge bioconda`
